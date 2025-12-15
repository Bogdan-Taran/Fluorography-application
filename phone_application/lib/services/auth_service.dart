import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:project_fluorography/models/user_model.dart';
import 'package:project_fluorography/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<UserData?> signInUser(
      String login,
      String password,
      ) async {
      List<UserData> data = _apiService.loginUser(login, password);
  }

  Future<bool> hasAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token != null){
      return true;
    }
    else{
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

  void login(String login, String password){
    // _apiService.loginUser(login, password);
    final data = _apiService.loginUser(login, password);
    String token = data['token'];

  }
}