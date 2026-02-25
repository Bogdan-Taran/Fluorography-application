import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/user_model.dart';
import 'package:project_fluorography/services/api_service.dart';
import 'package:project_fluorography/services/converters_service.dart';
import 'package:project_fluorography/services/shared_pref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final UserSharedPreferences _userSharedPreferences = UserSharedPreferences();
  final talker = Talker();


  Future<Either<Map<String, dynamic>, UserData?>> signInUser(String login, String password) async {
    try{
      final loginResult = await _apiService.loginUserDio(login, password);
      talker.info('AuthService: Отправил запрос SignInUser');
      if(loginResult['success'] == true){
        talker.info('AuthService: запрос SignInUser успешен');
        final hasToken = await hasAuthToken();
        if(hasToken){
          talker.info('AuthService: SignInUser токен имеется');
          try {
            final getDataResult = await _apiService.getProtectedDataDio();
            talker.info('AuthService: отправляю запрос getProtectedDataDio');
            if(getDataResult['success'] == true){
              talker.info('AuthService: запрос getProtectedDataDio успешен');
              final userData = UserData.fromJson(await getDataResult['data']);
              //сохраняем пользователя локально
              await _userSharedPreferences.saveUserDataIntoSharedPreferences(userData);
              return Right(userData);
            }
            else{
              talker.error('AuthService: запрос getProtectedDataDio ошибка: ${getDataResult['data']}');
              return Left({
                'statusCode': getDataResult['statusCode'],
                'data': getDataResult['data'],
              });
            }
          } catch (e) {
            talker.error('There appeared an unexpected error while sign in user');
            talker.handle(e);
            return Left({
              'statusCode': 0,
              'data': e.toString(),
            });
          }
        }
        else{
          talker.error('AuthService: отстствует токен');
          return Left({
            'statusCode': 401,
            'data': 'Отсутствует токен доступа',
          });
        }
      }
      else{
        talker.error('AuthService: запрос SignInUser ошибка: ${loginResult['data']}');
        return Left({
          'statusCode': loginResult['statusCode'],
          'data': loginResult['data']
        });
      }
    } catch (e) {
      talker.handle('AuthService: Возникла ошибка при попытке залогиниться: ${e.toString()}');
      return Left({
        'statusCode': 0,
        'data': 'Возникла ошибка при попытке залогиниться: ${e.toString()}',
      });
    }
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


}




