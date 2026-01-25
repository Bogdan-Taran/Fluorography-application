import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';

import '../../services/api_service_get_community_members.dart';
import '../../services/auth_service.dart';
import '../../services/localDataBase.dart';

part 'curator_event.dart';

part 'curator_state.dart';

class CuratorBloc extends Bloc<CuratorEvent, CuratorState> {
  ApiServiceGetCommunityMembers _ApiServiceGetCommunityMembers = ApiServiceGetCommunityMembers();
  AuthService _AuthService = AuthService();
  CheckerCacheService _CheckerCacheService = CheckerCacheService();

  CuratorBloc() : super(CuratorInitial()) {
    on<CuratorInitialEvent>(curatorInitialEvent);
  }

  FutureOr<void> curatorInitialEvent(
    CuratorInitialEvent event,
    Emitter<CuratorState> emit,
  ) async {
    emit(CuratorFetchingLoadingState());
    List<SingleGroupWithStudentsModel> curatorGroups;


    try{
      curatorGroups = await _CheckerCacheService.getGroupsCuratorWithCache();
      // if(curatorGroups.isNotEmpty){
      //   emit(CuratorLoadedGroupsSuccessfulState(curatorGroups: curatorGroups));
      // }
      // curatorGroups = await _ApiServiceGetCommunityMembers.getGroupsForCurator();
      print(curatorGroups.toString());
      emit(CuratorLoadedGroupsSuccessfulState(curatorGroups: curatorGroups));
    }
    catch (e){
      emit(CuratorFetchingErrorState());
      print('Не удалось получить группы для куратора');
      print(e);
    }
  }

}
