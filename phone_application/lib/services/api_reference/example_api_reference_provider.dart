import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/services/api_reference/api_references_provider.dart';

final exampleApiReferenceProvider = Provider<ExampleApiReferenceProvider>((ref) {
  final dio = ref.read(dioProvider);
  return ExampleApiReferenceProvider(dio);
});

class ExampleApiReferenceProvider {
  final Dio _dio;

  ExampleApiReferenceProvider(this._dio);

  Future<Response> getRequest(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<Response> postRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      throw Exception('Failed to post data');
    }
  }
}















