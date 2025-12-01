import '../models/student_models.dart';

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