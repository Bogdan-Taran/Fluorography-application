import 'package:project_fluorography/models/get_reference_model/get_reference_model.dart';
import 'package:project_fluorography/models/post_reference_model/post_reference_model.dart';
import 'package:project_fluorography/services/api_reference/request_reference_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

//контроллер для управления состояниями - некая прослойка-посредник между UI и всеми предыдущими иерархиями провайдеров
part 'request_reference_controller.g.dart';

@riverpod
Future<List<GetReferenceModel>> fetchStudentApplication(Ref ref){
  final repositoryProvider = ref.watch(requestRepositoryMineProvider);
  return repositoryProvider.getOneStudentApplications();
}

@riverpod
Future<List<GetReferenceModel>> fetchEntireListApplications(Ref ref){
  final repositoryProvider = ref.watch(requestRepositoryMineProvider);
  return repositoryProvider.getEntireListApplications();
}

final groupedApplicationsByGroup = Provider<AsyncValue<Map<String, List<GetReferenceModel>>>>((ref){
  final rawApplications = ref.watch(fetchEntireListApplicationsProvider);
  return rawApplications.whenData((list){
    final Map<String, List<GetReferenceModel>> groupedApplications = {};
    for(var item in list){
      if(!groupedApplications.containsKey(item.group)){
        groupedApplications[item.group] = [];
      }
      groupedApplications[item.group]!.add(item);
    }
    return groupedApplications;
  });
});

















