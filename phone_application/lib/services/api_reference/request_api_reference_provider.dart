import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/services/api_reference/api_references_provider.dart';
import 'package:talker/talker.dart';

final requestApiReferenceProvider = Provider<RequestApiReferenceProvider>((ref) {
  final dio = ref.read(dioProvider);
  return RequestApiReferenceProvider(dio);
});

class RequestApiReferenceProvider {
  final Dio _dio;
  final talker = Talker();

  RequestApiReferenceProvider(this._dio);

  Future<Response> getRequest(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    }
    catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<Response> postRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    }
    catch (e) {
      talker.handle(e);
      throw Exception('Failed to post data');
    }
  }
}















