import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker/talker.dart';
import '../../styles.dart';
import '../api_service.dart';

//экземпляр api сервиса
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

//провайдер к токену
final tokenProvider = FutureProvider<String>((ref) async {
  final talker = Talker();
  final apiService = ref.read(apiServiceProvider);
  final token = await apiService.getToken();
  talker.log('TokenProvider: токен получен: $token');
  return token!;
});



/*
// предоставляет базу Dio во всём приложении
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://flura.tomtit-tomsk.ru',
      connectTimeout: Duration(seconds: 2),
      receiveTimeout: Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // final token = await apiService.getToken();
        final token = tokenProvider;
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ),
  );
  return dio;
});*/


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
      onError: (DioException e, handler){
        if(e.response?.statusCode == 401){
          talker.log('DioProvider: Ошибка 401');
          // ref.read(apiServiceProvider).removeToken();
        }
        return handler.next(e);
      }
    )
  );
  return dio;
});















