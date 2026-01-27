part of 'working_with_fluorography_bloc.dart';

abstract class WorkingWithFluorographyState {}

final class WorkingWithFluorographyInitial extends WorkingWithFluorographyState{}

class EditModeWorkingWithFluorographyState extends WorkingWithFluorographyState{}
class CancelEditModeWorkingWithFluorographyState extends WorkingWithFluorographyState{}
class EnableEditModeWorkingWithFluorographyState extends WorkingWithFluorographyState{}
class OpenedDatePickerState extends WorkingWithFluorographyState{}



class SelectDateState extends WorkingWithFluorographyState{
  final DateTime? selectedDate;
  SelectDateState({
    this.selectedDate
  });

  @override
  List<Object> get props => [?selectedDate];

  SelectDateState copyWith({
    DateTime? selectedDate,
  }){
    return SelectDateState(selectedDate: selectedDate ?? this.selectedDate);
  }
}

