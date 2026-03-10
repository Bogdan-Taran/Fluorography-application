import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../styles.dart';
import '../api_service.dart';

//экземпляр api сервиса
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

//провайдер к токену
final tokenProvider = FutureProvider<String?>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getToken();
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
      onRequest: (options, handler) {
        final token = ref.watch(tokenProvider);
        options.headers['Authorization'] = token;
        return handler.next(options);
      }
    )
  );
  return dio;
});















