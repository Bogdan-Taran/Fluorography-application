import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/main.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import 'package:project_fluorography/services/api_reference/dio_and_interceptors/interceptor_provider.dart';
import 'package:talker/talker.dart';
import '../../api_service.dart';
import '../token_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final talker = Talker();
  final requestInterceptor = ref.watch(interceptorProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://flura.tomtit-tomsk.ru',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 8),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  dio.interceptors.add(requestInterceptor);
  return dio;
});
