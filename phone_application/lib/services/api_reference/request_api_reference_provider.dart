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
    } on DioException catch(error){
      talker.error('Dio ошибка: ${error}');
      talker.debug('StatusCode: ${error.response?.statusCode}');


      switch(error.response?.statusCode){
        case 422:
          talker.log('Ошибка 422');
          talker.log('${error.response!.data['message']}');
          /*
          * Либо неверно заполнено фио (не та группа, нет отчества, не совпадают ФИ
          * Либо уже запрашивал данную справку
          * */
        case 500:
          talker.error('Ошибка сервера');
        case 302:
          talker.error('Ошибка 302');
      }
      return error.response?.data;
    }
  }
}















