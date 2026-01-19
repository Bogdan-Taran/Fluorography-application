part of 'curator_bloc.dart';

@immutable
abstract class CuratorState {}

abstract class CuratorActionState extends CuratorState{}

final class CuratorInitial extends CuratorState {}

class CuratorFetchingLoadingState extends CuratorState{}
class CuratorFetchingErrorState extends CuratorState{}

class CuratorLogOutSuccessfulState extends CuratorActionState{}
class CuratorLogOutErrorState extends CuratorState{}


class CuratorLoadedGroupsSuccessfulState extends CuratorState {
  final List<SingleGroupWithStudentsModel> curatorGroups;

  CuratorLoadedGroupsSuccessfulState({
    required this.curatorGroups
  });
}
