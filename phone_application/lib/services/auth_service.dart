import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/user_model.dart';
import 'package:project_fluorography/services/api_service.dart';
import 'package:project_fluorography/services/converters_service.dart';
import 'package:project_fluorography/services/shared_pref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import 'api_reference/request_provider.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final UserSharedPreferences _userSharedPreferences = UserSharedPreferences();
  final talker = Talker();



  Future<Either<Map<String, dynamic>, UserData?>> signInUser(String login, String password) async {
    talker.info('AuthService: Начало процесса авторизации для $login');
    try {
      // 1. Пытаемся залогиниться
      final loginResult = await _apiService.loginUserDio(login, password);

      if (loginResult['success'] != true) {
        talker.error('AuthService: Ошибка логина: ${loginResult['data']}');
        return Left({
          'statusCode': loginResult['statusCode'],
          'data': loginResult['data']
        });
      }

      // 2. Если логин успешен, сразу запрашиваем данные профиля
      talker.info('AuthService: Логин успешен, запрашиваю данные профиля');
      final profileResult = await _apiService.getProtectedDataDio();

      if (profileResult['success'] == true) {
        final userData = UserData.fromJson(profileResult['data']);

        // 3. Сохраняем пользователя локально
        await _userSharedPreferences.saveUserDataIntoSharedPreferences(userData);
        talker.info('AuthService: Пользователь ${userData.firstname} успешно авторизован');

        return Right(userData);
      } else {
        talker.error('AuthService: Ошибка получения профиля: ${profileResult['data']}');
        return Left({
          'statusCode': profileResult['statusCode'],
          'data': profileResult['data'],
        });
      }
    } catch (e, st) {
      talker.handle(e, st, 'AuthService: Критическая ошибка при signInUser');
      return Left({
        'statusCode': 0,
        'data': 'Непредвиденная ошибка: $e',
      });
    }
  }

  Future<void> signOutUser() async {
    final bool hasToken = await hasAuthToken();
    if (hasToken) {
      talker.info('AuthService: Выход из системы, удаление токена');
      await _apiService.removeToken();
    } else {
      talker.warning('AuthService: Попытка выхода при отсутствии токена');
    }
  }

  Future<bool> hasAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token != null) {
      talker.log('Auth_servide: токен есть');
      return true;
    } else {
      talker.log('Auth_servide: токена нет');
      return false;
    }
  }

}




