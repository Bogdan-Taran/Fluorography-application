import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';

import '../../services/localDataBase.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  CheckerCacheService _CheckerCacheService = CheckerCacheService();
  AdminBloc() : super(AdminInitial()) {
    on<AdminInitialEvent>(adminInitialEvent);
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
}
