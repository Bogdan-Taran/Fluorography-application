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
  static const String _baseurl = 'http://192.168.13.19/api/login';
  static const String _loginUrl = '$_baseurl/api/profile';
  static const String _profileUrl = '$_baseurl/api/profile';

  Future<User> login(String login, String password) async{
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

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

  }





  Future<void> loginProfileGetRequest() async {
    print('toket yes yes');
    try {
      final prefs = await SharedPreferences.getInstance();
      final auth_token = await prefs.getString('auth_token');

      if (auth_token == null) {
        print('Токен отсутствует');
      }

      print("Токен есть, запрашиваю профиль");
      final response = await http.get(
        urlProfile,
        headers: {'Authorization': 'Bearer $auth_token'},
      );

      print("Ответ от api /api/profile: ${response.statusCode}");
      if (response.statusCode == 200) {
        print("Доступ получен. Получаю тело");

        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        final user = User(
          id: responseData['id'],
          firstname: responseData['firstname'],
          lastname: responseData['lastname'],
          patronymic: responseData['patronymic'],
          network_city_id: responseData['network_city_id'],
          roles: List<int>.from(responseData['roles'] ?? []),
        );

        setState(() {
          result =
              '''
          ID: ${user.id}
          Firstname: ${user.firstname}
          Lastname: ${user.lastname}
          Patronymic: ${user.patronymic}
          Network_city_id: ${user.network_city_id}
          Roles: ${user.roles}
          ''';
        });
        print("Данные успешно получены: $result");
      } else {
        print('Ошибка профиля: ${response.statusCode} - ${response.body}');
        throw Exception('Не удалось загрузить профиль');
      }
    } catch (e) {
      print('Ошибка в loginProflieGetRequest $e');
      setState(() {
        result = 'Error: $e';
      });
    }
  }

  Future<void> loginAuth({
    required String loginController,
    required String passwordController,
    required context,
    VoidCallback? isLoading,
  }) async {
    final login = loginController.toString();
    final password = passwordController.toString();


    if (login.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Заполните все поля')));
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        url,
        body: {'login': login, 'password': password},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // декодируем json
        final token = data['token'] as String?; // записываем выданный нам токен

        if (token != null) {
          // если токен не пустой
          //сохранение токена
          final prefs =
              await SharedPreferences.getInstance(); // активируем shared preferences
          await prefs.setString('auth_token', token); // записываем в память
          print('Авторизация успешна!, Токен $token');
          await loginProfileGetRequest(); // вызываем функцию авторизацию по роли
        } else {
          throw Exception('Токен не получен');
        }
      } else {
        //вывод всевозмоных ошибок
        print('Ошибка авторизации. Код ${response.statusCode}');
        print('Ответ сервра: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный логин или пароль')),
        );
      }
    } catch (e) {
      print('Исключение авторизации: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ошибка подключения')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
