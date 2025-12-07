import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'events.dart';
import 'states.dart';
import '../services/api_service.dart';
import '../models/student_models.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final ApiService _apiService;

  StudentBloc({required ApiService apiService}) : _apiService = apiService,
  super(StudentInitial()) {
    on<LoadAllStudents>(_onLoadAllStudents);
    on<LoadCuratorStudents>(_onLoadCuratorStudents);
    on<SearchStudents>(_onSearchStudents);
    on<RefreshStudents>(_onRefreshStudents);
  }

  Future<void> _onLoadAllStudents(
      LoadAllStudents event,
      Emitter<StudentState> emit
      ) async {
    emit(StudentLoading());
    try {
      final groups = await _apiService.fetchAllGroupsWithStudents();
      emit(StudentLoaded(groups));
    }catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onLoadCuratorStudents(
      LoadCuratorStudents event,
      Emitter<StudentState> emit,
      ) async{
    emit(StudentLoading());
    try{
      final groups = await _apiService.fetchGroupWithStudents(event.groupNumber);
      emit(StudentLoaded([groups]));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onLoadAdminStudents(
      LoadAdminStudents event,
      Emitter<StudentState> emit,
      ) async {
    emit(StudentLoading());
    try{
      final groups = await _apiService.fetchAllGroupsWithStudents();
      emit(StudentLoaded(groups));
    }catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onSearchStudents(
      SearchStudents event,
      Emitter<StudentState> emit,
      ) async {
    if (state is StudentLoaded) {
      final loadedState = state as StudentLoaded;
      final query = event.query.trim().toLowerCase();

      if(query.isEmpty){
        emit(loadedState);
      }
      else if(query.length >=3) {
        final filteredGroups = _filterGroups(loadedState.groups, query);
        emit(StudentFiltered(filteredGroups));
      }
    }
  }

  Future<void> _onRefreshStudents(
      RefreshStudents event,
      Emitter<StudentState> emit,
      ) async{
    emit(StudentInitial());
  }

  List<GroupWithStudents> _filterGroups(
      List<GroupWithStudents> groups,
      String query,
      ) {
    return groups.map((group) {
      final matchingStudents = group.students.where((s) => s.searchKey.contains(query)).toList();
      return matchingStudents.isEmpty ? null : group.copyWith(students: matchingStudents);
    }).whereType<GroupWithStudents>().toList();
  }
}