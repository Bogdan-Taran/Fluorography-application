import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/services/api_reference/token_provider.dart';
import 'package:talker/talker.dart';

import '../../../main.dart';
import '../../../screens/sign_in.dart';
import '../../api_service.dart';

final interceptorProvider = Provider((ref) => RequestInterceptor(ref));


class RequestInterceptor extends Interceptor{
  final Ref ref;
  RequestInterceptor(this.ref);
  final talker = Talker();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    talker.info('Interceptor: Checking token for ${options.path}...');
    
    try {
      // .future гарантирует, что мы дождемся завершения загрузки токена, 
      // если он еще в состоянии loading.
      final String? token = await ref.read(tokenProvider.future);

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        talker.info('Interceptor: Token added to headers');
      } else {
        talker.warning('Interceptor: Token is NULL or EMPTY, not added to headers');
      }
    } catch (e) {
      talker.error('Interceptor: Error fetching token: $e');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler){
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async{
    if(err.response?.statusCode == 401){
      talker.error('InterceptorProvider: ошибка 401');
      // await ref.read(apiServiceProvider).removeToken();
      // ref.invalidate(tokenProvider);
      // navigatorKey.currentState?.pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => const SignInScreen()),
      //       (route) => false,
      // );
    }
    
    final dataError = err.response?.data;
    talker.error('InterceptorProvider: блок onError, ошибка: $dataError');
    // Пробрасываем ошибку дальше, не резолвим её как успех
    // Ошибки должны оставаться ошибками
    super.onError(err, handler);
  }




}