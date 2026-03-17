import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/models/get_reference_model/get_reference_model.dart';
import 'package:project_fluorography/models/post_reference_model/post_reference_model.dart';
import 'package:project_fluorography/services/api_reference/api_references_provider.dart';
import 'package:talker/talker.dart';

/*
//предоставляет базовые Api запросы по шаблону
final requestApiReferenceProvider = Provider<RequestApiReferenceProvider>((ref) {
  final dio = ref.read(dioProvider);
  return RequestApiReferenceProvider(dio);
});

class RequestApiReferenceProvider {w=
  final Dio _dio;
  final talker = Talker();

  RequestApiReferenceProvider(this._dio);

  Future<Response> getRequest(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    }
    catch (e) {
      throw Exception('Ошибка при попытке получить данные');
    }
  }

  Future<PostReferenceModel> postRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return PostReferenceModel.fromJson(response.data);
    } on DioException catch(error){
      talker.error('Dio ошибка: ${error}, StatusCode: ${error.response?.statusCode},');
      switch(error.response?.statusCode){
        case 422:
          talker.log('Ошибка 422, type: ${error.type}');
          throw Exception('Ошибка 422');
        case 500:
          talker.error('Ошибка сервера');
        case 302:
          talker.error('Ошибка 302');
      }
      return error.response?.data;
    }
  }
}*/


final apiProviderMine = Provider<ApiProviderMine>((ref) {
  final dio = ref.watch(dioProviderMine);
  return ApiProviderMine(dio);
} );

class ApiProviderMine{
  final Dio _dio;
  ApiProviderMine(this._dio);
  final talker = Talker();

  Future<List<dynamic>> getRequest(String path) async{
    try{
      final response = await _dio.get(path);
      talker.log('ApiProvider: response отправлен и получен: ${response.data}');
      final data = response.data;
      if(data is Map<String, dynamic>){
        if(data.containsKey('message')){
          final message = data['message'];
          talker.warning('ApiProvider: message получен: $message');
          return [];
        }
      }
      if(data is List<dynamic>){
        talker.log('ApiProvider: Данные получены: $data');
        return data;
      }
      throw Exception('Ошибка при получении данных');
    } on DioException catch(error){
      talker.handle(error);
      throw('Возникла ошибка при попытке запросить данные');
    }
  }

  Future<PostReferenceModel> postRequest(String path, Map<String, dynamic> data) async{
    try{
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch(error){
      talker.handle(error);
      throw('Произошла ошибка при отправке данных');
    }
  }

  Future<Map<String, dynamic>> patchRequest(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(path, data: data);
      talker.log('ApiProvider: Данные успешно обновлены: $response');
      if(response.data is Map<String, dynamic>){
        return response.data;
      }
      return {'success': 'true'};
    } on DioException catch(error) {
      talker.handle(error);
      throw('ApiProvider: Произошла ошибка при обновлении данных');
    }
  }
}















