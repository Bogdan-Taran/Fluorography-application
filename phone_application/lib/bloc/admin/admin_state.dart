part of 'admin_bloc.dart';

@immutable
abstract class AdminState {}

abstract class AdminActionState extends AdminState{}

final class AdminInitial extends AdminState {}
class AdminFetchingLoadingState extends AdminState{}
class AdminFetchingErrorState extends AdminState{
  final String? message;
  AdminFetchingErrorState({this.message});
}
class AdminLoadedGroupsSuccessfulState extends AdminState{
  final List<SingleGroupWithStudentsModel> adminGroups;
  AdminLoadedGroupsSuccessfulState({required this.adminGroups});
}


class AdminSearchState extends AdminState{
  final List<SingleGroupWithStudentsModel>? filteredStudents;
  AdminSearchState({this.filteredStudents});
}
class AdminNoDataState extends AdminState{}
class AdminFilteredState extends AdminState{
  final List<SingleGroupWithStudentsModel> filteredStudents;
  AdminFilteredState({required this.filteredStudents});
}
class AdminUsualState extends AdminState{}

class AdminLogoutSuccessfulState extends AdminState{}
class AdminLogoutErrorState extends AdminState{
  final String? message;
  AdminLogoutErrorState({this.message});
}











