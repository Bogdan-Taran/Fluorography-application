import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/staff_and_students_model.dart';

import '../../services/api_service.dart';
import '../../services/api_service_get_community_members.dart';
import '../../services/auth_service.dart';
import '../../services/localDataBase.dart';

part 'medic_event.dart';
part 'medic_state.dart';

class MedicBloc extends Bloc<MedicEvent, MedicState> {
  ApiServiceGetCommunityMembers _ApiServiceGetCommunityMembers = ApiServiceGetCommunityMembers();
  AuthService _AuthService = AuthService();
  ApiService _ApiService = ApiService();
  CheckerCacheService _CheckerCacheService = CheckerCacheService();

  MedicBloc() : super(MedicInitial()) {
    on<MedicInitialEvent>(medicInitialEvent);
    on<MedicLogoutEvent>(medicLogoutEvent);
    on<MedicOpenDatePickerEvent>(medicOpenDatePickerEvent);
    on<MedicSelectDateEvent>(medicSelectDateEvent);
    on<MedicCloseDatePickerEvent>(medicCloseDatePickerEvent);

}
  FutureOr<void> medicInitialEvent(MedicInitialEvent event, Emitter<MedicState> emit) async{
    emit(MedicFetchingLoadingState());
    List<StaffAndStudentsModel> staffAndStudentsList;


    try{
      staffAndStudentsList = await _CheckerCacheService.getGroupsMedicWithCache();
      emit(MedicLoadedCommunitySuccessfulState(medicEntireCommunity: staffAndStudentsList));
      print('Студенты и сотрудники успешно получны');
    }catch (e){
      emit(MedicFetchingErrorState());
      print('Не удалось загрузить студентов с сотрудниками');
      log(e.toString());
    }


  }

  FutureOr<void> medicLogoutEvent(MedicLogoutEvent event, Emitter<MedicState> emit) async {
    emit(MedicFetchingLoadingState());
    try{
      await _AuthService.signOutUser();
      emit (MedicLogoutSuccessfulState());
      print('Излучил успешное состояние выхода');
    }
    catch (e){
      print('error while logout');
      print(e.toString());
    }
    emit(MedicLogoutErrorState());
  }


  FutureOr<void> medicOpenDatePickerEvent(MedicOpenDatePickerEvent event, Emitter<MedicState> emit) {
    print('Начинаю излучать открытие пикера');
    emit(MedicOpenDatePickerState());
    print('Излучил открытие пикера');
  }



  FutureOr<void> medicSelectDateEvent(MedicSelectDateEvent event, Emitter<MedicState> emit) async {
    emit(MedicFetchingLoadingState());
    try{
      await _ApiService.updateFluraDate(event.selectedDate);
      emit(MedicCloseDatePickerState());
    }catch (e){
      print('Произошла ошибка fetch-a');
      log(e.toString());
    }


  }

  FutureOr<void> medicCloseDatePickerEvent(MedicCloseDatePickerEvent event, Emitter<MedicState> emit) {
    emit(MedicCloseDatePickerState());
  }
}

