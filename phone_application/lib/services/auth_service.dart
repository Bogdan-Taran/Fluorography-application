import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:project_fluorography/models/user_model.dart';
import 'package:project_fluorography/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiService _apiService = ApiService();


  Future<UserData?> signInUser(String login, String password) async {
    try{
      print('Try to login user through api');
      await _apiService.loginUser(login, password);
      print('Try to get boolean hasToken');
      final bool hasToken = await hasAuthToken();
      print('Start to check if there any token');
      if(hasToken){
        print('Send request to get Pretected Data through api');
        final jsonData = _apiService.getProtectedData();
        print('Try to convert data from json');
        final userData = UserData.fromJson(await jsonData);
        print('Try to return userData');
        return userData;
      }
      else{
        print('Неверный логин или пароль');
        throw ('Unexpected error - do not have token');
      }
    }
    catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> signOutUser() async{
    final bool hasToken = await hasAuthToken();
    if(hasToken){
      print('Токен имеется, выхожу из системы');
      _apiService.removeToken();
    }
    else{
      print('токена не было, не могу выйти');
    }
  }

  Future<bool> hasAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> authContorller() async {
    final controller = StreamController<bool>();
  }
}

class AuthState extends ChangeNotifier {
  bool isAuthenticated = false;
  String userId = '';
  final ApiService _apiService = ApiService();

  void login(String login, String password) {
    // _apiService.loginUser(login, password);
    final data = _apiService.loginUser(login, password);

  }
}
