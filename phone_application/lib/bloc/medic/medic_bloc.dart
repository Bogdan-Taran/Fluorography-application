import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/models/staff_and_students_model.dart';
import 'package:project_fluorography/models/staff_model.dart';

import '../../models/multipleGroupsModel.dart';
import '../../services/api_service.dart';
import '../../services/api_service_get_community_members.dart';
import '../../services/auth_service.dart';
import '../../services/localDataBase.dart';
import '../../widgets/main_content_accordion_builder_light.dart';

part 'medic_event.dart';
part 'medic_state.dart';

class MedicBloc extends Bloc<MedicEvent, MedicState> {
  ApiServiceGetCommunityMembers _ApiServiceGetCommunityMembers = ApiServiceGetCommunityMembers();
  AuthService _AuthService = AuthService();
  ApiService _ApiService = ApiService();
  CheckerCacheService _CheckerCacheService = CheckerCacheService();

  MedicBloc() : super(MedicInitial()) {
    // on<MedicInitialEvent>(medicInitialEvent);
    on<MedicLogoutEvent>(medicLogoutEvent);
    on<MedicOpenDatePickerEvent>(medicOpenDatePickerEvent);
    // on<MedicSelectDateEvent>(medicSelectDateEvent);
    on<MedicCloseDatePickerEvent>(medicCloseDatePickerEvent);
    on<MedicFetchedNewDateSetEvent>(medicFetchedNewDateSetEvent);
    on<OnTapTextFieldEvent>(onTapTextFieldEvent);
    on<SearchChangedMedicEvent>(searchChangedMedicEvent);
    on<OnTapOutsideTextFieldMedicEvent>(onTapOutsideTextFieldMedicEvent);
    on<MedicFetchEvent>(medicFetchEvent);

}/*
  FutureOr<void> medicInitialEvent(MedicInitialEvent event, Emitter<MedicState> emit) async{
    emit(MedicFetchingLoadingState());
    List<StaffAndStudentsModel> staffAndStudentsList;
    try{
      staffAndStudentsList = await _CheckerCacheService.getGroupsMedicWithCache();
      emit(MedicLoadedCommunitySuccessfulState(medicEntireCommunity: staffAndStudentsList));
      print('Студенты и сотрудники успешно получны');
      // emit(MedicNormalState());
      // print('Нормальное состояние');
    }catch (e){
      emit(MedicFetchingErrorState());
      print('Не удалось загрузить студентов с сотрудниками');
      log(e.toString());
    }
  }*/

  FutureOr<void> medicFetchEvent(MedicFetchEvent event, Emitter<MedicState> emit) async {
    emit(MedicFetchingLoadingState());
    List<StaffAndStudentsModel> allCommunity = await _ApiServiceGetCommunityMembers.getAllComuintyForMedic();
    print('Bloc Medic: Студенты и сотрудники успешно получны');
    //
    // final allStaff = allCommunity.expand((e) => e.staffList).toList();
    // if(allStaff.isNotEmpty){
    //   displayItem.add(StaffSection(title: 'Сотрудники', count: allStaff.length, staffList: allStaff));
    // }
    // for(var item in allCommunity){
    //   for(var group in item.studentsList){
    //     displayItem.add(GroupSection(title: 'Группа', count: group.students.length, groupNumber: group.groupNumber, students: group.students));
    //   }
    // }
    emit(MedicLoadedCommunitySuccessfulState(medicEntireCommunity: allCommunity));
  }


  FutureOr<void> medicLogoutEvent(MedicLogoutEvent event, Emitter<MedicState> emit) async {
    emit(MedicFetchingLoadingState());
    try{
      // await _AuthService.signOutUser();
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



  // FutureOr<void> medicSelectDateEvent(MedicSelectDateEvent event, Emitter<MedicState> emit) async {
  //   emit(MedicFetchingLoadingState());
  //   try{
  //     await _ApiService.updateFluraDate(event.selectedDate);
  //     emit(MedicCloseDatePickerState());
  //   }catch (e){
  //     print('Произошла ошибка fetch-a');
  //     log(e.toString());
  //   }
  //
  //
  // }

  FutureOr<void> medicCloseDatePickerEvent(MedicCloseDatePickerEvent event, Emitter<MedicState> emit) {
    emit(MedicCloseDatePickerState());
  }

  FutureOr<void> medicFetchedNewDateSetEvent(MedicFetchedNewDateSetEvent event, Emitter<MedicState> emit) async{
    // emit(MedicFetchingLoadingState());
    List<StaffAndStudentsModel> staffAndStudentsList;
    try{
      emit(MedicFetchingLoadingState());
      staffAndStudentsList = await _CheckerCacheService.getGroupsMedicWithCache();

      final updatedList = staffAndStudentsList.map((model) {
        final updatedStaffList = model.staffList.map((staff){
          final newDate = event.newDateSet[staff.id.toString()];
          if(newDate != null){
            return staff.copyWith(fluorography: newDate);
          }
          return staff;
        }).toList();

        final updatedStudentsList = model.studentsList.map((group){
          final updatedStudents = group.students.map((student){
            final newDate = event.newDateSet[student.id.toString()];
            if(newDate != null){
              return student.copyWith(fluorography: newDate);
            }
            return student;
          }).toList();
          return group.copyWith(students: updatedStudents);
        }).toList();
        return model.copyWith(
          studentsList: updatedStudentsList,
          staffList: updatedStaffList
        );
      }).toList();

      // изменять только секцию данной группы
      emit(MedicLoadedCommunitySuccessfulState(medicEntireCommunity: updatedList));
      print('Даты успешно изменены');
    }catch (e){
      emit(MedicFetchingErrorState());
      print('Не удалось обновить даты');
      log(e.toString());
    }
  }

  FutureOr<void> onTapTextFieldEvent(OnTapTextFieldEvent event, Emitter<MedicState> emit) {
    emit(MedicSearchState());
    /*
    final currentState = state;
    if(currentState is MedicLoadedCommunitySuccessfulState){
      print('Bloc: current is MedicLoadedCommunitySuccessfulState');
      emit(MedicSearchState(medicEntireCommunity: currentState.medicEntireCommunity));
    }
    else if(currentState is MedicSearchState){
      print('Bloc: current is MedicSearchState');
      emit(currentState);
    }
    emit(currentState);
     */
  }

  FutureOr<void> searchChangedMedicEvent(
      SearchChangedMedicEvent event,
      Emitter<MedicState> emit,
      ) {
    List<StaffAndStudentsModel>? entireGroups = event.entireGroups;
    List<StaffAndStudentsModel> filteredGroups = [];
    final query = event.query;
    if (query.isEmpty) {
      print('Bloc: query пустой');
      emit(MedicNoDataState());
    }
    print('Bloc: пришёл query: $query');
    if(entireGroups != null) {
      print('Bloc: пришедшие группы не пусты');
    print('Bloc: наичнаю сортировку');
      filteredGroups = entireGroups.map((e) {
      final matchingStaff = e.staffList.where((sta) => sta.searchKey.contains(query)).toList();
      final matchingStudent = e.studentsList.expand((group){
        return group.students.where((stu) => stu.searchKey.contains(query));
      }).toList();
      return matchingStaff.isEmpty & matchingStudent.isEmpty ? null :
      e.copyWith(staffList: matchingStaff, studentsList: [SingleGroupWithStudentsModel(groupNumber: '', students: matchingStudent)]);
    }).whereType<StaffAndStudentsModel>().toList();
    }

    if(filteredGroups != null){
      print('Отфильтровал. Вот что получилось: ${filteredGroups}');
      emit(MedicFilteredState(medicFilteredCommunity: filteredGroups));
    }
    // emit(MedicNoDataState());
  }

  FutureOr<void> onTapOutsideTextFieldMedicEvent(OnTapOutsideTextFieldMedicEvent event, Emitter<MedicState> emit) {
    emit(MedicUsualState());
  }


}

extension BlocReset on MedicBloc{
  void reset(dynamic initialState){
    emit(initialState);
  }
}

