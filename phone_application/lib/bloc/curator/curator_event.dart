part of 'curator_bloc.dart';

@immutable
abstract class CuratorEvent {
  const CuratorEvent();
}

class CuratorInitialEvent extends CuratorEvent{}
class CuratorFetchEvent extends CuratorEvent{}

class CuratorLogoutEvent extends CuratorEvent{}

class CuratorOpenDatePickerEvent extends CuratorEvent{}
class CuratorCloseDatePickerEvent extends CuratorEvent{}
class CuratorSelectDateEvent extends CuratorEvent{
  final String selectedDate;
  const CuratorSelectDateEvent({
    required this.selectedDate,
  });
}

class OnTapTextFieldEvent extends CuratorEvent{}
class SearchChangedCuratorEvent extends CuratorEvent{
  final String query;
  final List<SingleGroupWithStudentsModel>? groups;
  SearchChangedCuratorEvent({required this.query, this.groups});
}
class OnTapOutsideTextFieldCuratorEvent extends CuratorEvent{}

class CuratorFetchedNewDateSetEvent extends CuratorEvent{
  final Map<String, String> newDateSet;
  CuratorFetchedNewDateSetEvent({required this.newDateSet});
  List<Object> get props => [newDateSet];
}

