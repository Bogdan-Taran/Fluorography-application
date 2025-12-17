import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
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
          final userData = UserData.fromJson(await jsonData['data']);

          //сохраняем пользователя локально
          await saveUserDataIntoSharedPreferences(userData);
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

    await prefs.setInt('id', UserData.id);
    await prefs.setString('firstname', UserData.firstname);
    await prefs.setString('lastname', UserData.lastname);
    await prefs.setString('patronymic', UserData.patronymic);
    await prefs.setInt('network_city_id', UserData.network_city_id);
    final String? userNormalNamedRole = await convertUserRoleFormListToNormalName(UserData);
    await prefs.setString('role', userNormalNamedRole!);
    await prefs.setStringList('groups', UserData.groups);
  }


  Future<String?> convertUserRoleFormListToNormalName(UserData) async{
    final List<int> userRoles = UserData.roles;
    final String userRole;
    if(userRoles.contains(1)){
      userRole = 'medic';
    }
    else if(userRoles.contains(2)){
      userRole = 'student';
    }
    else if (userRoles.contains(4)){
      userRole = 'admin';
    }
    else if(userRoles.contains(5)){
      userRole = 'curator';
    }
    else{
      userRole = 'undefined';
    }
    return userRole;
  }

}


class UserSharedPreferences{

  Future<void> getUserFromSharedPreferences() async{
    final prefs = await SharedPreferences.getInstance();
    print('Typing all values about user from shared preferences');

    print(prefs.getInt('id'));
    print(prefs.getString('firstname'));
    print(prefs.getString('lastname'));
    print(prefs.getString('patronymic'));
    print(prefs.getInt('network_city_id'));
    print(prefs.getString('role'));
    print(prefs.getStringList('groups'));
  }
  Future<String?> getUserFirstnameFromSharedPreferences() async{
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('firstname'));
    return prefs.getString('firstname');
  }
}



