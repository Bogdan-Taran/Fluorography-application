//провайдер к токену
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker/talker.dart';

import '../api_service.dart';
import 'dio_and_interceptors/dio_provider.dart';

final tokenProvider = FutureProvider<String?>((ref) async {
  final talker = Talker();
  final apiService = ref.read(apiServiceProvider);
  final token = await apiService.getToken();
  talker.log('TokenProvider: токен получен: $token');
  return token;
});