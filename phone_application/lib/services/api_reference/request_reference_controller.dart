import 'package:project_fluorography/models/get_reference_model/get_reference_model.dart';
import 'package:project_fluorography/models/post_reference_model/post_reference_model.dart';
import 'package:project_fluorography/services/api_reference/request_reference_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'request_reference_controller.g.dart';

@riverpod
class RequestReferenceController extends _$RequestReferenceController {
  RequestRepository get _repository => ref.read(requestRepositoryProvider);

  @override
  FutureOr<GetReferenceModel> build() async {
    return _repository.getAllApplications();
  }

  Future<void> PostReferenceRequest(PostReferenceModel postModel) async{
    await _repository.fetchApplication(postModel);
  }
}
