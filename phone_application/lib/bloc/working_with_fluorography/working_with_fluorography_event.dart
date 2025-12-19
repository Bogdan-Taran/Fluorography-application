part of 'working_with_fluorography_bloc.dart';

abstract class WorkingWithFluorographyEvent {
  const WorkingWithFluorographyEvent();
  List<Object> get props => [];
}

class SearchCommunityEvent extends WorkingWithFluorographyEvent{
  final String query;
  SearchCommunityEvent(this.query);
}

class UpdateFluorographyDateEvent extends WorkingWithFluorographyEvent{
  final int studentId;
  final DateTime newDate;
  UpdateFluorographyDateEvent(this.studentId, this.newDate);
}



