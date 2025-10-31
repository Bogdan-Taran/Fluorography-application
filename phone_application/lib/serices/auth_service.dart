//здесь происходит получение/чтение роли из БД (админ, препод, медик)
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String? patronymic;
  final int network_city_id;
  final List<int> roles;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    this.patronymic,    // отчества может и не быть, поэтому не required
    required this.network_city_id,
    required this.roles,
  });
}

class AuthService {
  static const String _baseurl = 'http://192.168.13.19';
  static const String _loginUrl = '$_baseurl/api/login';
  static const String _profileUrl = '$_baseurl/api/profile';

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
      id: profileData['id'],
      firstname: profileData['firstname'],
      lastname: profileData['lastname'],
      patronymic: profileData['patronymic'],
      network_city_id: profileData['network_city_id'],
      roles: List<int>.from(profileData['roles'] ?? []),
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
