part of 'admin_bloc.dart';

@immutable
sealed class AdminState {}

final class AdminInitial extends AdminState {}

class AdminFetchingLoadingState extends AdminState{}
class AdminFetchingErrorState extends AdminState{}

class AdminLoadedGroupsSuccessfulState extends AdminState{
  final List<SingleGroupWithStudentsModel> adminGroups;
  AdminLoadedGroupsSuccessfulState({required this.adminGroups});
}
