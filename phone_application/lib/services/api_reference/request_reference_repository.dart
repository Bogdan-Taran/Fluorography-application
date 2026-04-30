import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/models/get_reference_model/get_reference_model.dart';
import 'package:project_fluorography/models/post_reference_model/post_reference_model.dart';
import 'package:project_fluorography/services/api_reference/request_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import 'dio_and_interceptors/dio_provider.dart';

part 'request_reference_repository.g.dart';

@riverpod
RequestRepository requestRepository(Ref ref) {
  final apiProvider = ref.watch(apiProviderMine);
  return RequestRepository(apiProvider);
}
class RequestRepository {
  final ApiProviderMine _apiProviderMine;

  RequestRepository(this._apiProviderMine);

  final talker = Talker();

  Future<List<GetReferenceModel>> getOneStudentApplications({
    required int user_id,
  }) async {
    try {
      final response = await _apiProviderMine.getRequest(
        '/api/applications/$user_id',
      );
      talker.log(
        'RepoProvider: Данные получены, но не приведены к List: $response',
      );
      final List<dynamic> rawData = response;
      final List<GetReferenceModel> dataList = rawData
          .map(
            (json) => GetReferenceModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      talker.log(
        'RepoProvider: Данные успешно переконвертированы в List: $dataList',
      );
      return dataList;
    } on DioException catch (error) {
      talker.handle('Ошибка в репозитории: $error');
      throw ('Ошибка при получении справок студента');
    }
  }

  Future<List<GetReferenceModel>> getEntireListApplications() async {
    try {
      final response = await _apiProviderMine.getRequest('/api/applications');
      final List<dynamic> rawData = response;
      final List<GetReferenceModel> dataList = rawData
          .map(
            (json) => GetReferenceModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      talker.log(
        'RepoProvider(getEntireListApplications): Данные успешно переконвертированы в List: $dataList',
      );
      return dataList;
    } on DioException catch (error) {
      talker.handle('Ошибка в репозитории: $error');
      throw ('Ошибка при получении полного списка справок');
    }
  }

  Future<Map<String, dynamic>> updateReferenceStatus({
    required int status_id,
    required int application_id,
  }) async {
    try {
      final response = await _apiProviderMine.patchRequest(
        '/api/applications/$application_id',
        {'status_id': status_id},
      );
      talker.log(
        'RepoProvider(updateReferenceStatus): Данные успешно обновлены: $response',
      );
      return response;
    } on DioException catch (error) {
      talker.handle('Ошибка в репозитории: $error');
      throw ('Ошибка при обновлении статуса заявки');
    }
  }

  Future<String> logoutProfile() async {
    try {
        final response = await _apiProviderMine.getRequest('/api/logout');
        talker.log(
          'RepoProvider(logoutProfile): запрос на выход отправлен: $response',
        );
        if (response is Map<String, dynamic>) {
          if (response.containsKey('message')) {
            final message = response['message']?.toString() ?? 'Успешный выход';
            talker.warning(
              'RepoProvider(logoutProfile): message получен: $message',
            );
            return message;
          }
        }
        return response?.toString() ?? 'Выход выполнен';
    } on DioException catch (error) {
      talker.handle('Ошибка в репозитории: $error');
      throw ('Ошибка при попытке выйти');
    }
  }


  Future<String> postApplication({
    required PostReferenceModel data
  }) async {
    try {
      final response = await _apiProviderMine.postRequest(
        '/api/applications',
        data.toJson(),
      );
      // Если postRequest вернул данные успешно, извлекаем message
      final responseMessage = response['message']?.toString() ?? 'Заявка успешно отправлена';
      talker.log('RepoProvider: ответ от сервера: $responseMessage');
      return responseMessage;
    } catch (error) {
      talker.error('RepoProvider: Ошибка при отправке заявки: $error');
      // Пробрасываем ошибку дальше (это может быть строка из postRequest или сообщение из DioException)
      if (error is DioException) {
         final serverData = error.response?.data;
         if (serverData is Map && serverData.containsKey('message')) {
           throw serverData['message'];
         }
         throw 'Ошибка сети или сервера';
      }
      rethrow;
    }
  }
}
