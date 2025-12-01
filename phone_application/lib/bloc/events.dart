abstract class StudentEvent {}

class LoadAllStudents extends StudentEvent {}

class LoadCuratorStudents extends StudentEvent{
  final String groupNumber;

  LoadCuratorStudents(this.groupNumber);
}

class LoadAdminStudents extends StudentEvent {}

class SearchStudents extends StudentEvent{
  final String query;

  SearchStudents(this.query);
}

class RefreshStudents extends StudentEvent {}

