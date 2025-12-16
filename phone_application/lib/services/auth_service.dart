import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:project_fluorography/models/user_model.dart';
import 'package:project_fluorography/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiService _apiService = ApiService();


  Future<UserData?> signInUser(String login, String password) async {
    try{
      _apiService.loginUser(login, password);
      final bool hasToken = await hasAuthToken();
      if(hasToken){
        final jsonData = _apiService.getProtectedData();
        final userData = UserData.fromJson(await jsonData);
        return userData;
      }
      else{
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
    final _controller = StreamController<bool>();
  }
}

class AuthState extends ChangeNotifier {
  bool isAuthenticated = false;
  String userId = '';
  ApiService _apiService = ApiService();

  void login(String login, String password) {
    // _apiService.loginUser(login, password);
    final data = _apiService.loginUser(login, password);

  }
}
