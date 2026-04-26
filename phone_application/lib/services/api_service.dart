import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
//экземпляр api сервиса
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
class ApiService {
  final String _baseUrl = 'https://flura.tomtit-tomsk.ru';
  final talker = Talker();
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://flura.tomtit-tomsk.ru',
      connectTimeout: Duration(seconds: 8),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    )
  );

  Future<Map<String, dynamic>> loginUserDio(String login,
      String password) async {
    try {
      talker.info('ApiService: Попытка входа для $login');
      Response response = await dio.post(
        '/api/login',
        data: {
          'login': login,
          'password': password,
        },
      );

      final parsedJson = response.data;
      final String token = parsedJson['token'];
      await _saveToken(token);

      talker.info('ApiService: Авторизация успешна. Токен получен.');

      return {
        'success': true,
        'data': parsedJson,
        'statusCode': response.statusCode,
      };
    } on DioException catch (e) {
      String errorMessage = 'Произошла ошибка при входе';
      int statusCode = e.response?.statusCode ?? 0;

      if (e.type == DioExceptionType.badResponse) {
        final data = e.response?.data;
        if (statusCode == 401) {
          errorMessage = 'Ошибка авторизации: проверьте логин и пароль';
        } else if (statusCode >= 500) {
          errorMessage = 'Ошибка сервера (${statusCode}). Попробуйте позже';
        } else if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'];
        }
      }
      // Обработка проблем с сетью
      else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Время ожидания истекло. Проверьте соединение';
      } else if (e.error is HandshakeException) {
        errorMessage = 'Ошибка безопасности (SSL). Cертификат просрочен. Это внешняя проблема.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Отсутствует интернет-соединение или сервер недоступен';
      }

      talker.error(
          'ApiService: Ошибка loginUserDio ($statusCode): $errorMessage');
      if (e.error is HandshakeException) {
        talker.error('ApiService: Детали SSL: ${e.error}');
      }

      return {
        'success': false,
        'data': errorMessage,
        'statusCode': statusCode,
      };
    } catch (e) {
      talker.handle(e, StackTrace.current,
          'ApiService: Непредвиденная ошибка в loginUserDio');
      return {
        'success': false,
        'data': 'Внутренняя ошибка приложения',
        'statusCode': 500,
      };
    }
  }

  Future<Map<String, dynamic>> getProtectedDataDio() async{
    try {
      final token = await getToken();
      if (token == null) {
        return {
          'statusCode': 401,
          'success': false,
          'data': 'Пользователь не авторизован'
        };
      }
      Response response = await dio.get(
          '/api/profile',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token'
            },
          )
      );
      if (response.statusCode == 200) {
        final data = response.data;
        talker.log('Запрос на получение данных пользователя успешен');
        return {
          'statusCode': 200,
          'success': true,
          'data': data
        };
      }
      else if (response.statusCode == 401) {
        await removeToken();
        return {
          'success': false,
          'data': response.data,
          'statusCode': 401,
        };
      }
      else if (
      response.statusCode == 500 ||
          response.statusCode == 501 ||
          response.statusCode == 502 ||
          response.statusCode == 503) {
        return {
          'success': false,
          'data': response.data,
          'statusCode': response.statusCode
        };
      }
      else {
        final errorData = response.data;
        return {
          'success': false,
          'data': errorData,
          'statusCode': 401,
        };
      }
    } catch(e){
      talker.handle(e.toString());
      return {
        'success': false,
        'data': e,
        'statusCode': 0,
      };
    }
  }


  //сохранение токена
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  //получение токена
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> removeToken() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }




  // цикл для обновления выбранных дат
  Future<Map<String, dynamic>> updateFluraDateFromSet(Map<String, String> dateMap) async{
    talker.info('ApiService: Запуск цикла обновления дат (кол-во: ${dateMap.length})');
    final token = await getToken();
    if(token == null){
      talker.error('ApiService: Ошибка обновления - токен отсутствует');
      return {'success': false, 'data': 'Токен отсутствует'};
    }
    try {
      for(final entry in dateMap.entries){
        final uniqueId = entry.key;
        talker.debug('ApiService: Обновление даты для ID: $uniqueId');
        final selectedDate = entry.value;
        final patchData = await updateFluraDateDio(selectedDate, uniqueId, token);
        if(!patchData['success']){
          talker.error('ApiService: Остановка цикла, ошибка на ID $uniqueId');
          return {'success': false, 'data': patchData['data']};
        }
      }
      talker.info('ApiService: Все даты успешно обновлены');
      return {'success': true, 'data': 'Все даты успешно обновлены'};
    } catch(e, st){
      talker.handle(e, st, 'ApiService: Исключение в updateFluraDateFromSet');
      return {'success': false, 'data': 'Ошибка при массовом обновлении'};
    }
  }

  Future<Map<String, dynamic>> updateFluraDateDio(String selectedDate, String uniqueId, String token) async {
    try{
      talker.debug('ApiService: Отправка PATCH для $uniqueId');
      Response response = await dio.patch(
        '/api/fluorography/$uniqueId',
        data: {
          'date': selectedDate
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token'
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      if(response.statusCode == 200){
        talker.info('ApiService: Дата для $uniqueId успешно обновлена');
        return {'success': true, 'data': response.data};
      }
      
      talker.error('ApiService: PATCH failed [$uniqueId]: ${response.data} (Status: ${response.statusCode})');
      return {
        'success': false, 
        'data': 'Ошибка при обновлении: ${response.statusCode}',
        'statusCode': response.statusCode,
      };
    }
    catch (e, st) {
      talker.handle(e, st, 'ApiService: Ошибка PATCH запроса для $uniqueId');
      return {'success': false, 'data': 'Ошибка соединения'};
    }
  }


/*
  Future<void> updateFluraDate(String selectedDate, String uniqueId, String token) async {
    final url = Uri.parse('https://flura.tomtit-tomsk.ru/api/fluorography/$uniqueId');
    // String selectedDate = '2025-11-21';
    try {
      print('Пробую патчить дату');
      final response = await http.patch(
        url,
        headers: {
          'Content-Type':'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'date': selectedDate,
        }),
      );
      print('Закончил пробовать');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('Post patched: $jsonData');
      } else {
        print('Failed to patch post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while patching: $e');
    }
  }*/

}