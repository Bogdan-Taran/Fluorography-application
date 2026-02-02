part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchChangedEvent extends SearchEvent{
  final String query;
  final List<SingleGroupWithStudentsModel>? allGroups;
  final List<StaffAndStudentsModel>? entireGroups;
  SearchChangedEvent({required this.query, this.allGroups, this.entireGroups});
}
