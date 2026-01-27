part of 'working_with_fluorography_bloc.dart';

// abstract class WorkingWithFluorographyState extends Equatable{
class WorkingWithFluorographyState extends Equatable{
  final Map<String, bool> editingStates;
  WorkingWithFluorographyState({this.editingStates = const {}});

  WorkingWithFluorographyState copyWith({Map<String, bool>? editingStates}){
    return WorkingWithFluorographyState(
      editingStates: editingStates ?? this.editingStates
    );
  }
  @override
  List<Object> get props => [editingStates];
}

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

  // SelectDateState copyWith({
  //   DateTime? selectedDate,
  // }){
  //   return SelectDateState(selectedDate: selectedDate ?? this.selectedDate);
  // }
}

