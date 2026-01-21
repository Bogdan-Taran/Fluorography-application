import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/staff_and_students_model.dart';

import '../../services/api_service_get_community_members.dart';

part 'medic_event.dart';
part 'medic_state.dart';

class MedicBloc extends Bloc<MedicEvent, MedicState> {
  ApiServiceGetCommunityMembers _ApiServiceGetCommunityMembers = ApiServiceGetCommunityMembers();

  MedicBloc() : super(MedicInitial()) {
    on<MedicInitialEvent>(medicInitialEvent);
}
  FutureOr<void> medicInitialEvent(MedicInitialEvent event, Emitter<MedicState> emit) async{
    emit(MedicFetchingLoadingState());
    final List<StaffAndStudentsModel> staffAndStudentsList;
    try{
      staffAndStudentsList = await _ApiServiceGetCommunityMembers.getAllComuintyForMedic();
      // print(staffAndStudentsList.toString());
      emit(MedicLoadedCommunitySuccessfulState(medicEntireCommunity: staffAndStudentsList));
      print('Студенты и сотрудники успешно получны');
    }catch (e){
      emit(MedicFetchingErrorState());
      print('Не удалось загрузить студентов с сотрудниками');
      log(e.toString());
    }


  }
}

