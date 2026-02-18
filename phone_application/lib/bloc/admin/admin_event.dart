part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent {}

class AdminInitialEvent extends AdminEvent{}
class AdminFetchEvent extends AdminEvent{}

class AdminLogoutEvent extends AdminEvent{}

class OnTapTextFieldEvent extends AdminEvent{}
class SearchChangedAdminEvent extends AdminEvent{
  final String query;
  final List<SingleGroupWithStudentsModel>? groups;
  SearchChangedAdminEvent({required this.query, this.groups});
}
class OnTapOutsideTextFieldAdminEvent extends AdminEvent{}
