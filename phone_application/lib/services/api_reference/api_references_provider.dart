import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/main.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import 'package:talker/talker.dart';
import '../../styles.dart';
import '../api_service.dart';

//экземпляр api сервиса
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

//провайдер к токену
final tokenProvider = FutureProvider<String?>((ref) async {
  final talker = Talker();
  final apiService = ref.read(apiServiceProvider);
  final token = await apiService.getToken();
  talker.log('TokenProvider: токен получен: $token');
  return token;
});


final dioProviderMine = Provider<Dio> ((ref) {
  final talker = Talker();
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://flura.tomtit-tomsk.ru',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 8),
      headers: {
        'Content-Type' : 'application/json',
        'Accept' : 'application/json',
      }
    )
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async{
        try {
          final token = await ref.read(tokenProvider.future);
          talker.log('Interceptor: Токен: $token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }catch(e){
          talker.handle('Ошибка при получении токена: $e');
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if(e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          talker.warning('DioProvider: Ошибка ${e.response?.statusCode}. Очистка данных и выход.');
          await ref.read(apiServiceProvider).removeToken();
          ref.invalidate(tokenProvider);
          navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false
          );
        }
        return handler.next(e);
      }
    )
  );
  return dio;
});















