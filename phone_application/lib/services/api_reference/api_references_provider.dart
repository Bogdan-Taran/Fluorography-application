import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final tokenProvider = FutureProvider<String?>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getToken();
});

final dioProvider = Provider<Dio>((ref) {
  final apiService = ref.read(apiServiceProvider);

  final dio = Dio(
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

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await apiService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ),
  );
  return dio;
});















