part of 'working_with_fluorography_bloc.dart';

abstract class WorkingWithFluorographyEvent extends Equatable{
  const WorkingWithFluorographyEvent();
  @override
  List<Object> get props => [];
}

class LoadCuratorGroupsEvent extends WorkingWithFluorographyEvent{
  final List<String> groupNumber;
  const LoadCuratorGroupsEvent(this.groupNumber);
}

class LoadAllStudentsEvent extends WorkingWithFluorographyEvent{}

class SearchCommunityEvent extends WorkingWithFluorographyEvent{
  final String query;
  const SearchCommunityEvent(this.query);
}

class UpdateFluorographyDateEvent extends WorkingWithFluorographyEvent{
  final int studentId;
  final DateTime newDate;
  const UpdateFluorographyDateEvent(this.studentId, this.newDate);
}

class CancelEditingModeEvent extends WorkingWithFluorographyEvent{}
class EnableEditingModeEvent extends WorkingWithFluorographyEvent{}

class SelectDateEvent extends WorkingWithFluorographyEvent{
  final DateTime selectedDate;
  const SelectDateEvent({
    required this.selectedDate
  });
  @override
  List<Object> get props => [selectedDate];
}


