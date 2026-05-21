import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:project_fluorography/models/get_reference_model/get_reference_model.dart';
import 'package:project_fluorography/models/post_reference_model/post_reference_model.dart';
import 'package:project_fluorography/services/api_reference/request_reference_repository.dart';
import 'package:project_fluorography/services/api_reference/token_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../main.dart';
import '../api_service.dart';

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
      await ref.read(requestRepositoryProvider).logoutProfile();
    } catch (e) {
      talker.error('Ошибка при уведомлении сервера о выходе: $e');
    } finally {
      await ref.read(apiServiceProvider).removeToken();
      ref.invalidate(tokenProvider);

      if (navigatorKey.currentContext != null) {
        BlocProvider.of<AuthenticationBloc>(navigatorKey.currentContext!)
            .add(IsAuthenticatedCheckEvent());
      }

      state = const AsyncValue.data('Выход выполнен успешно');
    }
  }
}

@riverpod
Future<({List<GetReferenceModel> applications, String? message})> fetchEntireListApplications(
  Ref ref, {
  String? name,
  String? group,
  bool? onlyUnfinished,
}) {
  final repositoryProvider = ref.watch(requestRepositoryProvider);
  return repositoryProvider.getEntireListApplications(
    name: name,
    group: group,
    onlyUnfinished: onlyUnfinished,
  );
}

final groupedApplicationsByGroup =
    Provider.family<AsyncValue<({Map<String, List<GetReferenceModel>> groups, String? message})>, ({String? name, bool? onlyUnfinished})>((ref, arg) {
      final rawApplications = ref.watch(fetchEntireListApplicationsProvider(
        name: arg.name,
        onlyUnfinished: arg.onlyUnfinished,
      ));

      return rawApplications.whenData((result) {
        final list = result.applications;
        final Map<String, List<GetReferenceModel>> groupedApplications = {};
        final Map<String, Map<int, GetReferenceModel>> tempGrouped = {};
        final Map<int, String> studentPhones = {};

        for (var item in list) {
          final userId = item.user_id;

          if (item.phone != 'Телефон не указан' &&
              item.phone.isNotEmpty &&
              item.phone != 'Не указан') {
            studentPhones[userId] = item.phone;
          }

          if (!tempGrouped.containsKey(item.group)) {
            tempGrouped[item.group] = {};
          }

          final existing = tempGrouped[item.group]![userId];

          if (existing == null ||
              (item.status_id == 1 && existing.status_id != 1) ||
              (item.status_id == 3 &&
                  existing.status_id != 1 &&
                  existing.status_id != 3)) {
            tempGrouped[item.group]![userId] = item;
          }
        }

        tempGrouped.forEach((groupName, studentMap) {
          groupedApplications[groupName] = studentMap.values.map((student) {
            final phone = studentPhones[student.user_id];
            if (phone != null &&
                (student.phone == 'Не указан' || student.phone == 'Телефон не указан')) {
              return student.copyWith(phone: phone);
            }
            return student;
          }).toList();
        });

        return (groups: groupedApplications, message: result.message);
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

  Future<void> updateMultipleStatuses({required Map<int, int> updates, required int userId}) async {
    final repository = ref.read(requestRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      for (var entry in updates.entries) {
        await repository.updateReferenceStatus(status_id: entry.value, application_id: entry.key);
      }
      ref.invalidate(fetchEntireListApplicationsProvider);
      ref.invalidate(fetchStudentApplications(userId));
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
