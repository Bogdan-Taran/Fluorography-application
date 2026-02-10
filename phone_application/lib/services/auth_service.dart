import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/user_model.dart';
import 'package:project_fluorography/services/api_service.dart';
import 'package:project_fluorography/services/converters_service.dart';
import 'package:project_fluorography/services/shared_pref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final UserSharedPreferences _userSharedPreferences = UserSharedPreferences();


  Future<UserData?> signInUser(String login, String password) async {
    try{
      //await _apiService.loginUser(login, password);
      await _apiService.loginUserDio(login, password);
      final bool hasToken = await hasAuthToken();
      if(hasToken){
        try {
          final jsonData = await _apiService.getProtectedDataDio();
          // NotAuthenticatedEvent
          final userData = UserData.fromJson(await jsonData['data']);

          //сохраняем пользователя локально
          await _userSharedPreferences.saveUserDataIntoSharedPreferences(userData);
          return userData;
        }
        catch (e) {
          print('There appeared an unexpected error while sign in user');
        }
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
    if (token != null) return true;
    else {
      return false;
    }
  }


}




