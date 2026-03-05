import 'package:project_fluorography/models/get_reference_model/get_reference_model.dart';
import 'package:project_fluorography/models/post_reference_model/post_reference_model.dart';
import 'package:project_fluorography/services/api_reference/request_reference_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'request_reference_controller.g.dart';
//контроллер для управления состояниями - некая прослойка-посредник между UI и всеми предыдущими иерархиями провайдеров
@riverpod
class RequestReferenceController extends _$RequestReferenceController {
  RequestRepository get _repository => ref.read(requestRepositoryProvider);

  @override
  FutureOr<GetReferenceModel> build() {
    return GetReferenceModel(
        id: 1, userId: 1, firstname: '1', lastname: '1', patronymic: '1', group: '1', typeId: 1, statusId: 1, quantity: 1, date: '1', phone: '1');
  }

  Future<GetReferenceModel> GetApplications() async {
    return _repository.getAllApplications();
  }

  Future<void> PostReferenceRequest(PostReferenceModel postModel) async{
    await _repository.fetchApplication(postModel);
  }
}
