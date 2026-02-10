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
/*
  Future<Map<String, dynamic>> getProtectedData() async {
    final token = await getToken();
    if (token == null) {
      return {'success': false, 'error': 'User not authenticated'};
    }
    // print('Token recieved');
    final url = Uri.parse('$_baseUrl/api/profile');
    // print('Sending a request');
    final response = await http.get(
      url,
      headers: {
        'Content-Type':'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    // print('response recieved');
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return {'success': true, 'data': data};
    }
    else if (response.statusCode == 401){
      await removeToken();
      // print('User unauthorized');
      return {'success': false, 'error': 'Authentication failed'};
      // TODO: сделать обработчик на view
    }
    else{
      print('THERE HAPPEND an unexpected - not 200');
      final errorData = jsonDecode(response.body);
      return {'success': false, 'error': errorData};
    }
  }*/

/*
  Future<Map<String, dynamic>> loginUser(String login, String password) async {
    final url = Uri.parse('$_baseUrl/api/login/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:jsonEncode({'login': login, 'password': password}),
    );

    if (response.statusCode == 200){
      final parsedJson = jsonDecode(response.body);
      await _saveToken(parsedJson['token']);
      final String token = parsedJson['token'];
      print('Токен получен: $token');
      return {'success': true, 'data': parsedJson};
    }
    else {
      final errorData = jsonDecode(response.body);
      return {'success': false, 'error': errorData};
    }
  }*/

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
  Future<void> updateFluraDateFromSet(Map<String, String> dateMap) async{
    print('Заупскаю цикл для обновления выбранных дат');
    final token = await getToken();
    try {
      await Future.forEach(
          dateMap.entries, (MapEntry<String, String> entry) async {
        final uniqueId = entry.key;
        print('Обновляю дату для $uniqueId');
        final selectedDate = entry.value;
        await updateFluraDate(selectedDate, uniqueId, token!);
      });
    } catch(e){
      print(e);
    }
  }
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
  }
}