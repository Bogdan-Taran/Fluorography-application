//здесь происходит получение/чтение роли из БД (админ, препод, медик)
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_fluorography/models/user_models.dart';

class AuthService {
  static const String _baseurl = 'http://flura.tomtit-tomsk.ru';
  static const String _loginUrl = '$_baseurl/api/login';
  static const String _profileUrl = '$_baseurl/api/profile';
  static const String _logoutUrl = '$_baseurl/api/logout';

  Future<User> login(String login, String password) async{
    //authorization
    final loginResponse = await http.post(
      Uri.parse(_loginUrl),
      body: {'login': login, 'password': password}
    );
    
    if(loginResponse.statusCode != 200){
      throw Exception('Неверный логин или пароль');
    }

    final loginData = jsonDecode(loginResponse.body);
    final token = loginData['token'] as String?;
    if(token == null) throw Exception('Токен не получен');

    // save token
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    // get profile
    final profileResponse = await http.get(
      Uri.parse(_profileUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (profileResponse.statusCode != 200){
      throw Exception('Не удалось загрузить профиль');
    }

    final profileData =jsonDecode(profileResponse.body) as Map<String, dynamic>;


    return User(
      id: profileData['id'] as int? ?? 0,
      firstname: profileData['firstname'] as String? ?? '',
      lastname: profileData['lastname'] as String? ?? '',
      patronymic: profileData['patronymic'] as String?,
      networkCityId: profileData['network_city_id'] as int? ?? 0,
      roles: List<int>.from(profileData['roles'] ?? []),
      groups: List<String>.from(profileData['groups'] ?? []),
    );
  }

  // func to get token from Shared Preferences
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // logout from app and remove auth token

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    // TODO:
    // realize exit the page
  }

}
