import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:project_fluorography/models/user_model.dart';
import 'package:project_fluorography/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiService _apiService = ApiService();


  Future<UserData?> signInUser(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();
    try{
      // print('Try to login user through api');
      await _apiService.loginUser(login, password);
      // print('Try to get boolean hasToken');
      final bool hasToken = await hasAuthToken();
      // print('Start to check if there any token');
      if(hasToken){
        try { // print('Send request to get Pretected Data through api');
          final jsonData = await _apiService.getProtectedData();
          print('typing jsonData');
          print(jsonData);
          final userData = UserData.fromJson(await jsonData['data']);

          print('Typing id user from auth service - from userData');
          print(userData.id);
          print(userData.groups);
          print(userData.firstname);
          print(userData.network_city_id);
          print(userData.roles);


          //сохраняем пользователя локально
          saveUserDataIntoSharedPreferences(userData);
          print('Typing a network city id');
          getUserFormSharedPreferences();
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
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveUserDataIntoSharedPreferences(UserData) async{
    final prefs = await SharedPreferences.getInstance();
    final int id;
    final String firstname;
    final String lastname;
    String? patronymic;
    final int network_city_id;
    final List<int> roles;
    final List<String> groups;

    await prefs.setInt('network_city_id', UserData.network_city_id);

    final int? id_user_from_shared = await prefs.getInt('network_city_id');
    print('$id_user_from_shared');

  }

  Future<void> getUserFormSharedPreferences() async{
    final prefs = await SharedPreferences.getInstance();

    final int? network_city_id_user = prefs.getInt('network_city_id');
    print('network_city_id_user: $network_city_id_user');
  }



}


