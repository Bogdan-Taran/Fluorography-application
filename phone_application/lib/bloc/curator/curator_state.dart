part of 'curator_bloc.dart';

@immutable
abstract class CuratorState {}

abstract class CuratorActionState extends CuratorState{}

final class CuratorInitial extends CuratorState {}
class CuratorFetchingLoadingState extends CuratorState{}
class CuratorFetchingErrorState extends CuratorState{
  final String? message;
  CuratorFetchingErrorState({this.message});
}
class CuratorLoadedGroupsSuccessfulState extends CuratorState {
  final List<SingleGroupWithStudentsModel> curatorGroups;
  CuratorLoadedGroupsSuccessfulState({
    required this.curatorGroups
  });
}

class CuratorSearchState extends CuratorState{
  final List<SingleGroupWithStudentsModel>? filteredStudents;
  CuratorSearchState({this.filteredStudents});
}
class CuratorNoDataState extends CuratorState{}
class CuratorFilteredState extends CuratorState{
  final List<SingleGroupWithStudentsModel> filteredStudents;
  CuratorFilteredState({required this.filteredStudents});
}
class CuratorUsualState extends CuratorState{}

class CuratorLogoutSuccessfulState extends CuratorState{}
class CuratorLogoutErrorState extends CuratorState{
  final String? message;
  CuratorLogoutErrorState({this.message});
}

class CuratorOpenDatePickerState extends CuratorState{}
class CuratorCloseDatePickerState extends CuratorState{}

