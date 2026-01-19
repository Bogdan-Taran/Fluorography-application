part of 'working_with_fluorography_bloc.dart';

abstract class WorkingWithFluorographyState extends Equatable {
  const WorkingWithFluorographyState();
  @override
  List<Object> get props => [];
}

class WorkingWithFluorographyInitial extends WorkingWithFluorographyState {}



class WorkingWithFluorographyLoadingState extends WorkingWithFluorographyState{
  final bool isLoading;
  const WorkingWithFluorographyLoadingState({required this.isLoading});
}

class WorkingWithFluorographyErrorState extends WorkingWithFluorographyState{
  final String errorMessage;
  const WorkingWithFluorographyErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class WorkingWithFluorographyLoadedState extends WorkingWithFluorographyState{
  final List<SingleGroupWithStudentsModel> students;
  const WorkingWithFluorographyLoadedState({required this.students});
  @override
  List<Object> get props => [students];
}

class WorkingWithFluorographyEditState extends WorkingWithFluorographyState{
  final List<SingleGroupWithStudentsModel> groups;
  final bool isEditing;

  const WorkingWithFluorographyEditState({required this.groups, required this.isEditing,});
  List<Object> get props => [isEditing];
}

class WorkingWithFluorographySearchState extends WorkingWithFluorographyState{}

class LoadCuratorGroupsState extends WorkingWithFluorographyState {
  final List<String> groupNumber;
  const LoadCuratorGroupsState(this.groupNumber);
}

class SelectDateState extends WorkingWithFluorographyState{
  final DateTime? selectedDate;
  const SelectDateState({
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


class LoadAllStudentsState extends WorkingWithFluorographyState{}
