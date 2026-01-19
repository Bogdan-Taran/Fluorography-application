import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';

import '../../services/api_service_get_community_members.dart';
import '../../services/auth_service.dart';

part 'curator_event.dart';

part 'curator_state.dart';

class CuratorBloc extends Bloc<CuratorEvent, CuratorState> {
  ApiServiceGetCommunityMembers _ApiServiceGetCommunityMembers = ApiServiceGetCommunityMembers();
  AuthService _AuthService = AuthService();

  CuratorBloc() : super(CuratorInitial()) {
    on<CuratorInitialEvent>(curatorInitialEvent);
    on<CuratorSignOutEvent>(curatorSignOutEvent);
  }

  FutureOr<void> curatorInitialEvent(
    CuratorInitialEvent event,
    Emitter<CuratorState> emit,
  ) async {
    emit(CuratorFetchingLoadingState());
    final List<SingleGroupWithStudentsModel> curatorGroups;
    try{
      curatorGroups = await _ApiServiceGetCommunityMembers.getGroupsForCurator();
      print(curatorGroups.toString());
      emit(CuratorLoadedGroupsSuccessfulState(curatorGroups: curatorGroups));
    }
    catch (e){
      emit(CuratorFetchingErrorState());
      print('Не удалось получить группы для куратора');
      print(e);
    }
  }

  FutureOr<void> curatorSignOutEvent(CuratorSignOutEvent event, Emitter<CuratorState> emit) async{
    emit(CuratorFetchingLoadingState());
    try{
      await _AuthService.signOutUser();
      emit (CuratorLogOutSuccessfulState());
      print('Излучил успешное состояние выхода');
    }
    catch (e){
      print('error while logout');
      print(e.toString());
    }
    emit(CuratorLogOutErrorState());
  }
}
