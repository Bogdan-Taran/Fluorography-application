import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
      BaseOptions(
        baseUrl: 'https://flura.tomtit-tomsk.ru',
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 8),
        headers: {'Content-Type': 'application/json'},
      )
  );
});















