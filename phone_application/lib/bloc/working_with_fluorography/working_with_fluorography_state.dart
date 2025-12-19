part of 'working_with_fluorography_bloc.dart';

abstract class WorkingWithFluorographyState {
  const WorkingWithFluorographyState();
  List<Object> get props => [];
}

class WorkingWithFluorographyInitial extends WorkingWithFluorographyState {}

class WorkingWithFluorographyLoadingState extends WorkingWithFluorographyState{
  final bool isLoading;
  WorkingWithFluorographyLoadingState({required this.isLoading});
}

class WorkingWithFluorographyLoadedState extends WorkingWithFluorographyState{
  final List<SingleGroupWithStudentsModel> students;
  WorkingWithFluorographyLoadedState({required this.students});
  @override
  List<Object> get props => [students];
}

class WorkingWithFluorographyErrorState extends WorkingWithFluorographyState{
  final String errorMessage;

  WorkingWithFluorographyErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class WorkingWithFluorographyEditState extends WorkingWithFluorographyState{
  final List<SingleGroupWithStudentsModel> groups;
  final bool isEditing;

  WorkingWithFluorographyEditState({required this.groups, required this.isEditing,});
  List<Object> get props => [isEditing];
}

class WorkingWithFluorographySearchState extends WorkingWithFluorographyState{}


