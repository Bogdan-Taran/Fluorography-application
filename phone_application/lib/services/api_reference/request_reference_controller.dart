import 'package:flutter_riverpod/legacy.dart';
import 'package:project_fluorography/models/get_reference_model/get_reference_model.dart';
import 'package:project_fluorography/models/post_reference_model/post_reference_model.dart';
import 'package:project_fluorography/services/api_reference/request_reference_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/services/api_reference/token_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import '../api_service.dart';
import 'dio_and_interceptors/dio_provider.dart';

part 'request_reference_controller.g.dart';

final fetchStudentApplications = FutureProvider.family<List<GetReferenceModel>, int> ((ref, user_id) {
  final repositoryProvider = ref.watch(requestRepositoryProvider);
  return repositoryProvider.getOneStudentApplications(user_id: user_id);
});


final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<String?>>((ref){
  return AuthController(ref);
});

class AuthController extends StateNotifier<AsyncValue<String?>>{
  final Ref ref;
  AuthController(this.ref) : super(const AsyncValue.data(null));
  final talker = Talker();

  Future<void> logout() async{
    try {
      // 1. Пытаемся уведомить сервер (пока токен еще есть)
      await ref.read(requestRepositoryProvider).logoutProfile();
    } catch (e) {
      // Логируем ошибку, но не прерываем процесс выхода
      talker.error('Ошибка при уведомлении сервера о выходе: $e');
    } finally {
      // 2. В любом случае очищаем локальные данные
      await ref.read(apiServiceProvider).removeToken();
      ref.invalidate(tokenProvider);

      // 3. Устанавливаем состояние успеха, чтобы сработал навигатор в UI
      state = const AsyncValue.data('Выход выполнен успешно');
    }
  }
}

@riverpod
Future<List<GetReferenceModel>> fetchEntireListApplications(Ref ref) {
  final repositoryProvider = ref.watch(requestRepositoryProvider);
  return repositoryProvider.getEntireListApplications();
}

final groupedApplicationsByGroup =
    Provider<AsyncValue<Map<String, List<GetReferenceModel>>>>((ref) {
      final rawApplications = ref.watch(fetchEntireListApplicationsProvider);
      return rawApplications.whenData((list) {
        final Map<String, List<GetReferenceModel>> groupedApplications = {};
        for (var item in list) {
          if (!groupedApplications.containsKey(item.group)) {
            groupedApplications[item.group] = [];
          }
          groupedApplications[item.group]!.add(item);
        }
        return groupedApplications;
      });
    });

@riverpod
class UpdateReferenceStatusController
    extends _$UpdateReferenceStatusController {
  @override
  FutureOr<void> build() {
  }
  Future<void> updateStatus({required int applicationId, required int statusId}) async {
    final repository = ref.read(requestRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updateReferenceStatus(status_id: statusId, application_id: applicationId);
      ref.invalidate(fetchEntireListApplicationsProvider);
    });
  }
}


@riverpod
class PostApplicationController extends _$PostApplicationController{
  final talker = Talker();

  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> submitApplication(PostReferenceModel data) async{
    final repository = ref.read(requestRepositoryProvider);
    state = await AsyncValue.guard(() async{
      final response = await repository.postApplication(data: data);
      talker.log('PostApplicationController: ответ: $response');
      return response;
    });
  }
}
