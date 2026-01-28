part of 'working_with_fluorography_bloc.dart';

abstract class WorkingWithFluorographyEvent extends Equatable{
  const WorkingWithFluorographyEvent();
  @override
  List<Object> get props => [];
}

class WorkingWithFluorographyInitialEvent extends WorkingWithFluorographyEvent{}

class LoadCuratorGroupsEvent extends WorkingWithFluorographyEvent{
  final List<String> groupNumber;
  const LoadCuratorGroupsEvent(this.groupNumber);
}


class SearchCommunityEvent extends WorkingWithFluorographyEvent{
  final String query;
  const SearchCommunityEvent(this.query);
}

class UpdateFluorographyDateEvent extends WorkingWithFluorographyEvent{
  final int studentId;
  final DateTime newDate;
  const UpdateFluorographyDateEvent(this.studentId, this.newDate);
}

class TurnOnEditingModeEvent extends WorkingWithFluorographyEvent{
  final String uniqueId;
  TurnOnEditingModeEvent({
    required this.uniqueId,
});
}

class CancelEditingModeEvent extends WorkingWithFluorographyEvent{
  final String uniqueId;
  CancelEditingModeEvent({required this.uniqueId});
}

class SaveEditingModeEvent extends WorkingWithFluorographyEvent{
  @override
  List<Object> get props => [];
}

class OpenDatePickerEvent extends WorkingWithFluorographyEvent{
  final String uniqueId;
  OpenDatePickerEvent({required this.uniqueId});
}
class CloseDatePickerEvent extends WorkingWithFluorographyEvent{
  final String uniqueId;
  CloseDatePickerEvent({required this.uniqueId});
}

class SelectDateEvent extends WorkingWithFluorographyEvent{
  final String uniqueContainerId;
  final String selectedDate;
  const SelectDateEvent({
    required this.selectedDate,
    required this.uniqueContainerId
  });
}


