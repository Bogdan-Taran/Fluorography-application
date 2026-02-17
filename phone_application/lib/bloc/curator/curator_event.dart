part of 'curator_bloc.dart';

@immutable
abstract class CuratorEvent {}

class CuratorInitialEvent extends CuratorEvent{}
class CuratorFetchEvent extends CuratorEvent{}

class CuratorLogoutEvent extends CuratorEvent{}
class SearchChangedCuratorEvent extends CuratorEvent{
  final String query;
  final List<SingleGroupWithStudentsModel>? groups;

  SearchChangedCuratorEvent({required this.query, this.groups});
}

class OnTapTextFieldEvent extends CuratorEvent{}

