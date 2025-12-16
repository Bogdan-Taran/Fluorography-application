import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  final String _baseUrl = 'http://flura.tomtit-tomsk.ru';

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




  Future<Map<String, dynamic>> getProtectedData() async {
    final token = await getToken();
    if (token == null) {
      return {'success': false, 'error': 'User not authenticated'};
    }
    print('Token recieved');
    final url = Uri.parse('$_baseUrl/api/profile');
    print('Sending a request');
    final response = await http.get(
      url,
      headers: {
        'Content-Type':'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    print('response recieved');
    if(response.statusCode == 200){
      print('statuscode is 200');
      print('Typing response.body');
      print(response.body);
      final data = jsonDecode(response.body);
      print(data);
      return {'success': true, 'data': data};
    }
    else if (response.statusCode == 401){
      await removeToken();
      print('User unauthorized');
      return {'success': false, 'error': 'Authentication failed'};
      // TODO: сделать обработчик на view
    }
    else{
      print('THERE HAPPEND an unexpected - not 200');
      final errorData = jsonDecode(response.body);
      return {'success': false, 'error': errorData};
    }
  }
}