part of 'curator_bloc.dart';

@immutable
abstract class CuratorState {}

//(не предназначен для отображения в UI - только действия(реакции): переходы, показ сообщения. Состояния, которые нужно обработать.
abstract class CuratorActionState extends CuratorState{}

final class CuratorInitial extends CuratorState {}

class CuratorFetchingLoadingState extends CuratorState{}
class CuratorFetchingErrorState extends CuratorState{}


class CuratorLoadedGroupsSuccessfulState extends CuratorState {
  final List<SingleGroupWithStudentsModel> curatorGroups;

  CuratorLoadedGroupsSuccessfulState({
    required this.curatorGroups
  });
}
