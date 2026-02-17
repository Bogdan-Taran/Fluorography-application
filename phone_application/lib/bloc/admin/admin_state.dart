part of 'admin_bloc.dart';

@immutable
sealed class AdminState {}

final class AdminInitial extends AdminState {}

class AdminFetchingLoadingState extends AdminState{}
class AdminFetchingErrorState extends AdminState{}
class AdminLoadedCommunitySuccessfulState extends AdminState{
  final List<SingleGroupWithStudentsModel> studentsList;
  AdminLoadedCommunitySuccessfulState({required this.studentsList});
}


class AdminLoadedGroupsSuccessfulState extends AdminState{
  final List<SingleGroupWithStudentsModel> adminGroups;
  AdminLoadedGroupsSuccessfulState({required this.adminGroups});
}
