part of 'working_with_fluorography_bloc.dart';

// abstract class WorkingWithFluorographyState extends Equatable{
class WorkingWithFluorographyState extends Equatable{
  final Map<String, bool> editingStates;
  final Map<String, String> tempDates;
  WorkingWithFluorographyState({
    this.editingStates = const {},
    this.tempDates = const {}
  });

  WorkingWithFluorographyState copyWith({
    Map<String, bool>? editingStates,
    Map<String, String>? tempDates,
  }){
    return WorkingWithFluorographyState(
      editingStates: editingStates ?? this.editingStates,
      tempDates: tempDates ?? this.tempDates,
    );
  }
  @override
  List<Object> get props => [editingStates, tempDates];
}

final class WorkingWithFluorographyInitial extends WorkingWithFluorographyState{}

class EditModeWorkingWithFluorographyState extends WorkingWithFluorographyState{}
class CancelEditModeWorkingWithFluorographyState extends WorkingWithFluorographyState{}
class EnableEditModeWorkingWithFluorographyState extends WorkingWithFluorographyState{}
class OpenedDatePickerState extends WorkingWithFluorographyState{}

class SuccessfullyPatchedSetDatesState extends WorkingWithFluorographyState{
  final Map<String, String> newDateSet;
  SuccessfullyPatchedSetDatesState({required this.newDateSet});
}



class SelectDateState extends WorkingWithFluorographyState{
  final DateTime? selectedDate;
  SelectDateState({
    this.selectedDate
  });

  @override
  List<Object> get props => [?selectedDate];

  // SelectDateState copyWith({
  //   DateTime? selectedDate,
  // }){
  //   return SelectDateState(selectedDate: selectedDate ?? this.selectedDate);
  // }
}

