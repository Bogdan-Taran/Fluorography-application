part of 'student_bloc.dart';

abstract class StudentEvent {}

class LoadAllStudents extends StudentEvent {}

class LoadCuratorStudents extends StudentEvent {
  final List<String> groupNumber;

  LoadCuratorStudents(this.groupNumber);
}

class LoadAdminStudents extends StudentEvent {}

class SearchStudents extends StudentEvent {
  final String query;

  SearchStudents(this.query);
}

class RefreshStudents extends StudentEvent {}

// Новые события для редактирования даты
class ToggleEditMode extends StudentEvent {
  final bool enabled;

  ToggleEditMode(this.enabled);
}

class UpdateFluorographyDate extends StudentEvent {
  final int studentId;
  final DateTime newDate;

  UpdateFluorographyDate(this.studentId, this.newDate);
}

class CancelEditMode extends StudentEvent {}