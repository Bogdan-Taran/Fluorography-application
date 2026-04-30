import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/models/get_reference_model/get_reference_model.dart';
import 'package:project_fluorography/models/post_reference_model/post_reference_model.dart';
import 'package:project_fluorography/services/api_reference/dio_and_interceptors/dio_provider.dart';
import 'package:talker/talker.dart';

final apiProviderMine = Provider<ApiProviderMine>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiProviderMine(dio);
} );

class ApiProviderMine{
  final Dio _dio;
  ApiProviderMine(this._dio);
  final talker = Talker();

  Future<dynamic> getRequest(String path, {Map<String, dynamic>? queryParameters}) async{
    try{
      final response = await _dio.get(path, queryParameters: queryParameters);
      talker.log('ApiProvider: response отправлен и получен: ${response.data}');
      final data = response.data;
      if(data is Map<String, dynamic>){
        if(data.containsKey('message')){
          final message = data['message'];
          talker.warning('ApiProvider: message получен: $message');
          return data;
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

  Future<Map<String, dynamic>> postRequest(String path, Map<String, dynamic> data) async{
    try{
      final response = await _dio.post(path, data: data);
      final responseData = response.data;
      talker.log('ApiProvider: $responseData, ${response.statusCode}');
      return responseData;
    } on DioException catch(error){
      final responseData = error.response?.data;
      talker.handle('request_api_reference_provider: $responseData');
      
      if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
        talker.info('Сервер вернул сообщение об ошибке: ${responseData['message']}');
        // Выбрасываем сообщение как ошибку, а не возвращаем его
        throw responseData['message'];
      }
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















