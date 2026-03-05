

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/models/get_reference_model/get_reference_model.dart';
import 'package:project_fluorography/models/post_reference_model/post_reference_model.dart';
import 'package:project_fluorography/services/api_reference/request_api_reference_provider.dart';

final requestRepositoryProvider = Provider<RequestRepository>((ref){
  final apiProvider = ref.read(requestApiReferenceProvider);
  return RequestRepository(apiProvider);
});

class RequestRepository {
  final RequestApiReferenceProvider _apiProvider;
  RequestRepository(this._apiProvider);

  Future<GetReferenceModel> getAllApplications() async{
    try{
      final response = await _apiProvider.getRequest('/api/applications');
      return GetReferenceModel.fromJson(response.data);
    } catch(e){
      throw Exception('Failed to load references data');
    }
  }

  Future<void> fetchApplication(
      PostReferenceModel referenceModel
      ) async {
    try{
      await _apiProvider.postRequest(
          '/api/applications',
          referenceModel.toJson()
      );
    } catch (e){
      throw Exception('Failed to post request on creating application');
    }
  }
}


// String firstname,
//     String lastname,
// String patronymic,
//     String group,
// int type_id,
//     String phone,
// int quantity,