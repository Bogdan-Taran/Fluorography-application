import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';

import '../../services/api_service_get_community_members.dart';
import '../../services/localDataBase.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  CheckerCacheService _CheckerCacheService = CheckerCacheService();
  ApiServiceGetCommunityMembers _ApiServiceGetCommunityMembers = ApiServiceGetCommunityMembers();
  AdminBloc() : super(AdminInitial()) {
    on<AdminInitialEvent>(adminInitialEvent);
    on<AdminFetchEvent>(adminFetchEvent);
    on<OnTapTextFieldEvent>(onTapTextFieldEvent);
  }

  FutureOr<void> adminInitialEvent(AdminInitialEvent event, Emitter<AdminState> emit) async{
    emit(AdminFetchingLoadingState());
    List<SingleGroupWithStudentsModel> adminGroups;

    try{
      adminGroups = await _CheckerCacheService.getGroupsAdminWithCache();
      emit(AdminLoadedGroupsSuccessfulState(adminGroups: adminGroups));
    } catch (e){
      emit(AdminFetchingErrorState());
      print('Не удалось получить группы для админа');
    }
  }

  FutureOr<void> adminFetchEvent(AdminFetchEvent event, Emitter<AdminState> emit) async {
    emit(AdminFetchingLoadingState());
    List<SingleGroupWithStudentsModel> studentsList = await _ApiServiceGetCommunityMembers.getStudentsWithFluraDio();
    emit(AdminLoadedGroupsSuccessfulState(adminGroups: studentsList));
  }

  FutureOr<void> onTapTextFieldEvent(OnTapTextFieldEvent event, Emitter<AdminState> emit) {
    emit(AdminSearchState());
  }
}
