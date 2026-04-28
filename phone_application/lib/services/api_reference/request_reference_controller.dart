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
        // Временная мапа для объединения заявок по студентам внутри каждой группы.
        final Map<String, Map<int, GetReferenceModel>> tempGrouped = {};
        // Мапа для хранения найденных номеров телефонов по user_id
        final Map<int, String> studentPhones = {};

        for (var item in list) {
          final userId = item.user_id;

          // Если в текущей заявке есть номер телефона, запоминаем его
          if (item.phone != 'Телефон не указан' && item.phone.isNotEmpty) {
            studentPhones[userId] = item.phone;
          }

          if (!tempGrouped.containsKey(item.group)) {
            tempGrouped[item.group] = {};
          }

          final existing = tempGrouped[item.group]![userId];

          // Приоритет заявке со статусом "В процессе" (1) для корректного отображения в списке
          if (existing == null || (existing.status_id != 1 && item.status_id == 1)) {
            tempGrouped[item.group]![userId] = item;
          }
        }

        // Собираем итоговый список, подставляя найденные телефоны
        tempGrouped.forEach((groupName, studentMap) {
          groupedApplications[groupName] = studentMap.values.map((student) {
            final phone = studentPhones[student.user_id];
            // Проверяем на старый и новый вариант текста "не указан" для надежности
            if (phone != null && 
                (student.phone == 'Не указан' || student.phone == 'Телефон не указан')) {
              return student.copyWith(phone: phone);
            }
            return student;
          }).toList();
        });

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
