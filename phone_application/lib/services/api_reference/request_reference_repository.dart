import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/models/get_reference_model/get_reference_model.dart';
import 'package:project_fluorography/models/post_reference_model/post_reference_model.dart';
import 'package:project_fluorography/services/api_reference/request_api_reference_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

part 'request_reference_repository.g.dart';


@riverpod
RequestRepositoryMine requestRepositoryMine(Ref ref){
  final apiProvider = ref.read(apiProviderMine);
  return RequestRepositoryMine(apiProvider);
}

class RequestRepositoryMine{
  final ApiProviderMine _apiProviderMine;
  RequestRepositoryMine(this._apiProviderMine);
  final talker = Talker();

  Future<List<GetReferenceModel>> getOneStudentApplications() async {
    try{
      final response = await _apiProviderMine.getRequest('/api/applications/1125');
      talker.log('RepoProvider: Данные получены, но не приведены к List: $response');
      final List<dynamic> rawData = response;
      final List<GetReferenceModel> dataList = rawData.map((json) => GetReferenceModel.fromJson(json as Map<String, dynamic>)).toList();
      talker.log('RepoProvider: Данные успешно переконвертированы в List: $dataList');
      return dataList;
    } on DioException catch(error){
      talker.handle('Ошибка в репозитории: $error');
      throw('Ошибка при получении справок студента');
    }
  }

  Future<List<GetReferenceModel>> getEntireListApplications() async{
    try {
      final response = await _apiProviderMine.getRequest('/api/applications');
      final List<dynamic> rawData = response;
      final List<GetReferenceModel> dataList = rawData.map((json) => GetReferenceModel.fromJson(json as Map<String, dynamic>)).toList();
      talker.log('RepoProvider(getEntireListApplications): Данные успешно переконвертированы в List: $dataList');
      return dataList;
    } on DioException catch(error){
      talker.handle('Ошибка в репозитории: $error');
      throw('Ошибка при получении полного списка справок');
    }
  }

  Future<Map<String, dynamic>> updateReferenceStatus(
      {required int status_id, required int application_id}) async{
    try {
      final response = await _apiProviderMine.patchRequest(
          '/api/applications/$application_id',
          {
            'status_id': 2,
          }
      );
      talker.log('RepoProvider(updateReferenceStatus): Данные успешно обновлены: $response');
      return response;
    } on DioException catch(error){
      talker.handle('Ошибка в репозитории: $error');
      throw('Ошибка при обновлении статуса заявки');
    }
  }
}