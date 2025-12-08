part of 'student_bloc.dart';


abstract class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<GroupWithStudents> groups;

  StudentLoaded(this.groups);
}

class StudentError extends StudentState {
  final String message;

  StudentError(this.message);
}

class StudentFiltered extends StudentState {
  final List<GroupWithStudents> filteredGroups;

  StudentFiltered(this.filteredGroups);
}

// Новое состояние для режима редактирования
class StudentEditState extends StudentState {
  final List<GroupWithStudents> groups;
  final bool isEditing;

  StudentEditState({
    required this.groups,
    required this.isEditing,
  });
}