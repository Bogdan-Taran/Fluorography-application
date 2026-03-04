import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final tokenProvider = FutureProvider<String>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  String? token = await apiService.getToken();
  if (token != null) {
    return token;
  } else {
    return 'null';
  }
});

final dioProvider = Provider<Dio>((ref)  {
  // final tokenAsyncValue = ref.watch(tokenProvider.future);
  return Dio(
    BaseOptions(
      baseUrl: 'https://flura.tomtit-tomsk.ru',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 8),
      headers: {
        'Content-Type': 'application/json',
        //if(tokenAsyncValue != 'null') 'Authorization': 'Bearer $tokenAsyncValue',
      },
    ),
  );
});
