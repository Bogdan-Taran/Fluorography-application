import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ApiService {
  final String _baseUrl = 'https://flura.tomtit-tomsk.ru';
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://flura.tomtit-tomsk.ru',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    )
  );

  Future<Map<String, dynamic>> loginUserDio(String login, String password) async{
      try{
        print('ApiService: Пробую логиниться');
        Response response = await dio.post(
            '/api/login',
            data: {
              'login': login,
              'password': password,
            }
        );
        if(response.statusCode == 200){
          final parsedJson = response.data;
          print('ApiService: запрос успешен, parsedJson: $parsedJson');
          final String token = parsedJson['token'];
          await _saveToken(token);
          print('Токен получен: $token');
          return {'success': true, 'data': parsedJson};
        }
        else{
          final errorData = response.data;
          print('ApiService: запрос неудача, errorData: $errorData');
          return {'success': false, 'error': errorData};
        }
      } catch (e){
        return {'success': false, 'error': 'Ошибка при попытке логина: $e'};
      }
  }

  Future<Map<String, dynamic>> getProtectedDataDio() async{
    final token = await getToken();
    if (token == null) {
      return {'success': false, 'error': 'User not authenticated'};
    }
    Response response = await dio.get(
      '/api/profile',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        },
      )
    );
    if(response.statusCode == 200){
      final data = response.data;
      return {'success': true, 'data': data};
    }
    else if (response.statusCode == 401){
      await removeToken();
      return {'success': false, 'error': 'Authentication failed'};
    }
    else{
      print('THERE HAPPEND an unexpected - not 200');
      final errorData = response.data;
      return {'success': false, 'error': errorData};
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
    print('Заупскаю цикл для обновления выбранных дат');
    final token = await getToken();
    if(token == null){
      print('Токен отсутствует');
      return {'success': false, 'data': 'There isn`t a token'};
    }
    try {
      for(final entry in dateMap.entries){
        final uniqueId = entry.key;
        print('Обновляю дату для $uniqueId');
        final selectedDate = entry.value;
        final patchData = await updateFluraDateDio(selectedDate, uniqueId, token);
        if(!patchData['success']){
      print('success: false');
          return {'success': false, 'data': patchData['data']};
        }
      }
      print('success: true');
      return {'success': true, 'data': 'All dates updates successfully'};
      /*
      await Future.forEach(
          dateMap.entries, (MapEntry<String, String> entry) async {
        final uniqueId = entry.key;
        print('Обновляю дату для $uniqueId');
        final selectedDate = entry.value;
        final patchData = await updateFluraDateDio(selectedDate, uniqueId, token);
        if(patchData['success']){
          return {'success': true, 'data': patchData['data']};
        }
        else{
          return {'success': false, 'data': patchData['data']};
        }
      });
      return {'success': false, 'data': 'Error in patching'};
      */
    } catch(e){
      print('Ошибка при патче в updateFluraDateFromSet: ${e.toString()}');
      return {'success': false, 'data': 'Catch exception'};
    }
  }

  Future<Map<String, dynamic>> updateFluraDateDio(String selectedDate, String uniqueId, String token) async {
    try{
      print('Пробую патчить дату для ID: $uniqueId');
      Response response = await dio.patch(
        '/api/fluorography/$uniqueId',
        data: {
          'date': selectedDate
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token'
          },
          validateStatus: (status){
            return status != null && status < 600;
          }
        ),

      );
      print('Закончил патчить');
      if(response.statusCode == 200){
        final data = response.data;
        print('Post patched: $data');
        return {'success': true, 'data': data};
      }
      else if(response.statusCode == 401){
        print('Failed to patch: Not authorized (${response.statusCode})');
        final data = response.data;
        return {'success': false, 'data': data};
      }
      else if(response.statusCode == 404){
        print('Failed to patch: Page not found (${response.statusCode})');
        final data = response.data;
        return {'success': false, 'data': data};
      }
      else if(response.statusCode == 502){
        print('Failed to patch: The server was unable to process the request (${response.statusCode})');
        final data = response.data;
        return {'success': false, 'data': data};
      }
      else{
        print('Failed to patch post: ${response.data} (${response.statusCode})');
        final data = response.data;
        return {'success': false, 'data': data};
      }
    }
    catch (e) {
      print('Catch: Error while patching date: $e');
      if(e is DioException){
        print('Ошибка в Dio: $e');
        return {'success': false, 'data': 'Dio exception'};
      }
      return {'success': false, 'data': 'Catch exception'};
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