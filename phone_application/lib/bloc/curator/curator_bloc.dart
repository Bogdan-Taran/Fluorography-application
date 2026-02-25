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
    // on<CuratorInitialEvent>(curatorInitialEvent);
    on<CuratorFetchEvent>(curatorFetchEvent);
    on<CuratorLogoutEvent> (curatorLogoutEvent);
    on<CuratorOpenDatePickerEvent>(curatorOpenDatePickerEvent);
    on<CuratorCloseDatePickerEvent>(curatorCloseDatePickerEvent);
    on<CuratorFetchedNewDateSetEvent>(curatorFetchedNewDateSetEvent);
    on<OnTapTextFieldEvent>(onTapTextFieldEvent);
    on<SearchChangedCuratorEvent>(searchChangedCuratorEvent);
  }

  FutureOr<void> curatorInitialEvent(
    CuratorInitialEvent event,
    Emitter<CuratorState> emit,
  ) async {
    emit(CuratorFetchingLoadingState());
    List<SingleGroupWithStudentsModel> curatorGroups;

    try{
      curatorGroups = await _CheckerCacheService.getGroupsCuratorWithCache();
      print(curatorGroups.toString());
      emit(CuratorLoadedGroupsSuccessfulState(curatorGroups: curatorGroups));
    }
    catch (e){
      emit(CuratorFetchingErrorState());
      print('Не удалось получить группы для куратора');
      print(e);
    }
  }


  FutureOr<void> curatorLogoutEvent(CuratorLogoutEvent event, Emitter<CuratorState> emit) async{
    emit(CuratorFetchingLoadingState());
    try{
      emit(CuratorLogoutSuccessfulState());
    } catch(e) {
      print('There is appeared an Error while LogOut Curator: ${e.toString()}');
      emit(CuratorLogoutErrorState());
    }
  }

  FutureOr<void> searchChangedCuratorEvent(SearchChangedCuratorEvent event, Emitter<CuratorState> emit) async{
    List<SingleGroupWithStudentsModel>? studentsGroup = event.groups;
    if(studentsGroup == null || event.query.isEmpty){
      emit(CuratorNoDataState());
      return;
    }

    final query = event.query.toLowerCase().trim();
    final filteredGroups = <SingleGroupWithStudentsModel>[];
    for(final group in studentsGroup){
      final matchingStudents = group.students.where((student) => student.searchKey.contains(query)).toList();
      if(matchingStudents.isNotEmpty){
        filteredGroups.add(SingleGroupWithStudentsModel(groupNumber: group.groupNumber, students: matchingStudents));
      }
    }
    if(filteredGroups.isEmpty){
      emit(CuratorNoDataState());
    } else{
      emit(CuratorFilteredState(filteredStudents: filteredGroups));
    }
  }

  FutureOr<void> onTapTextFieldEvent(OnTapTextFieldEvent event, Emitter<CuratorState> emit) {
    emit(CuratorSearchState());
  }

  FutureOr<void> curatorFetchEvent(CuratorFetchEvent event, Emitter<CuratorState> emit) async{
    emit(CuratorFetchingLoadingState());
    // List<SingleGroupWithStudentsModel> studentsList = await _ApiServiceGetCommunityMembers.getStudentsWithFluraDio();
    final data = await _ApiServiceGetCommunityMembers.getStudentsWithFluraDio();
    data.fold(
        (error){
          print('CuratorBloc: ошибка при получении студентов');
          emit(CuratorFetchingErrorState(message: error['data']));
        },
        (students){
          print('CuratorBloc: успех при получении студентов');
          List<SingleGroupWithStudentsModel> studentsList = students;
          emit(CuratorLoadedGroupsSuccessfulState(curatorGroups: studentsList));
        }
    );
  }

  FutureOr<void> curatorOpenDatePickerEvent(CuratorOpenDatePickerEvent event, Emitter<CuratorState> emit) {
    emit(CuratorOpenDatePickerState());
  }

  FutureOr<void> curatorCloseDatePickerEvent(CuratorCloseDatePickerEvent event, Emitter<CuratorState> emit) {
    emit(CuratorCloseDatePickerState());
  }

  FutureOr<void> curatorFetchedNewDateSetEvent(CuratorFetchedNewDateSetEvent event, Emitter<CuratorState> emit) async {
    List<SingleGroupWithStudentsModel> studentsList;
    try{
      studentsList = await _CheckerCacheService.getGroupsCuratorWithCache();
      final updatedStudentsList = studentsList.map((group){
        final updatedStudents = group.students.map((student){
          final newDate = event.newDateSet[student.id.toString()];
          if(newDate != null){
            return student.copyWith(fluorography: newDate);
          }
          return student;
        }).toList();
        return group.copyWith(students: updatedStudents);
      }).toList();
      emit(CuratorLoadedGroupsSuccessfulState(curatorGroups: updatedStudentsList));
    } catch(e){
      emit(CuratorFetchingErrorState());
    }

  }
}
