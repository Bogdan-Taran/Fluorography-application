import 'dart:async';
import 'package:bloc/bloc.dart';

import '../services/api_service.dart';
import '../models/student_models.dart';

part 'student_events.dart';

part 'student_states.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final ApiService _apiService;

  StudentBloc({required ApiService apiService})
    : _apiService = apiService,
      super(StudentInitial()) {
    on<LoadAllStudents>(_onLoadAllStudents);
    on<LoadCuratorStudents>(_onLoadCuratorStudents);
    on<RefreshStudents>(_onRefreshStudents);
    on<LoadAdminStudents>(_onLoadAdminStudents);
    on<SearchStudents>(_onSearchStudents);
    on<ToggleEditMode>(_onToggleEditMode);
    on<UpdateFluorographyDate>(_onUpdateFluorographyDate);
    on<CancelEditMode>(_onCancelEditMode);
  }

  Future<void> _onLoadAllStudents(
    LoadAllStudents event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      final groups = await _apiService.fetchAllGroupsWithStudents();
      emit(StudentLoaded(groups));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onLoadCuratorStudents(
    LoadCuratorStudents event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentLoading());
    try {
      final groups = await _apiService.fetchGroupWithStudents(
        event.groupNumber,
      );
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
    try {
      final groups = await _apiService.fetchAllGroupsWithStudents();
      emit(StudentLoaded(groups));
    } catch (e) {
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

      if (query.isEmpty) {
        emit(loadedState);
      } else if (query.length >= 3) {
        final filteredGroups = _filterGroups(loadedState.groups, query);
        emit(StudentFiltered(filteredGroups));
      }
    }
  }

  Future<void> _onRefreshStudents(
    RefreshStudents event,
    Emitter<StudentState> emit,
  ) async {
    emit(StudentInitial());
  }

  List<GroupWithStudents> _filterGroups(
    List<GroupWithStudents> groups,
    String query,
  ) {
    return groups
        .map((group) {
          final matchingStudents = group.students
              .where((s) => s.searchKey.contains(query))
              .toList();
          return matchingStudents.isEmpty
              ? null
              : group.copyWith(students: matchingStudents);
        })
        .whereType<GroupWithStudents>()
        .toList();
  }

  Future<void> _onToggleEditMode(
    ToggleEditMode event,
    Emitter<StudentState> emit,
  ) async {
    if (state is StudentLoaded) {
      final loadedState = state as StudentLoaded;
      emit(
        StudentEditState(groups: loadedState.groups, isEditing: event.enabled),
      );
    } else if (state is StudentFiltered) {
      final filteredState = state as StudentFiltered;
      emit(
        StudentEditState(
          groups: filteredState.filteredGroups,
          isEditing: event.enabled,
        ),
      );
    } else if (state is StudentEditState) {
      final editState = state as StudentEditState;
      emit(
        StudentEditState(groups: editState.groups, isEditing: event.enabled),
      );
    }
  }

  Future<void> _onUpdateFluorographyDate(
    UpdateFluorographyDate event,
    Emitter<StudentState> emit,
  ) async {
    try {
      // Обновляем дату на сервере
      await _apiService.updateFluorographyDate(event.studentId, event.newDate);

      // Обновляем состояние локально
      if (state is StudentEditState) {
        final editState = state as StudentEditState;
        final updatedGroups = _updateStudentDate(
          editState.groups,
          event.studentId,
          event.newDate,
        );
        emit(
          StudentEditState(
            groups: updatedGroups,
            isEditing: true, // остаемся в режиме редактирования
          ),
        );
      }
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  Future<void> _onCancelEditMode(
    CancelEditMode event,
    Emitter<StudentState> emit,
  ) async {
    // Возвращаемся к предыдущему состоянию без редактирования
    if (state is StudentEditState) {
      final editState = state as StudentEditState;
      emit(StudentLoaded(editState.groups));
    }
  }

  List<GroupWithStudents> _updateStudentDate(
    List<GroupWithStudents> groups,
    int studentId,
    DateTime newDate,
  ) {
    return groups.map((group) {
      final updatedStudents = group.students.map((student) {
        if (student.id == studentId) {
          return student.copyWith(dateFluorography: newDate);
        }
        return student;
      }).toList();
      return group.copyWith(students: updatedStudents);
    }).toList();
  }
}
