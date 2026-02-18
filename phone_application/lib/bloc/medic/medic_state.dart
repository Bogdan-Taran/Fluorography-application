part of 'medic_bloc.dart';

@immutable
abstract class MedicState {}

abstract class MedicActionState extends MedicState{}

// api, fetch
final class MedicInitial extends MedicState {}
class MedicFetchingErrorState extends MedicState{
  final String? message;
  MedicFetchingErrorState({this.message});
}
class MedicFetchingLoadingState extends MedicState{}
class MedicLoadedCommunitySuccessfulState extends MedicState{
  final List<StaffAndStudentsModel> medicEntireCommunity;
  MedicLoadedCommunitySuccessfulState({required this.medicEntireCommunity});
}

//search
class MedicSearchState extends MedicState{
  final List<StaffAndStudentsModel>? medicFilteredCommunity;
  MedicSearchState({this.medicFilteredCommunity});
}
class MedicNoDataState extends MedicState{}
class MedicFilteredState extends MedicState{
  final List<StaffAndStudentsModel> medicFilteredCommunity;
  MedicFilteredState({required this.medicFilteredCommunity});
}
class MedicUsualState extends MedicState{}

// authentication
class MedicLogoutSuccessfulState extends MedicState{}
class MedicLogoutErrorState extends MedicState{
  final String? message;
  MedicLogoutErrorState({this.message});
}

//select dates
class MedicOpenDatePickerState extends MedicState{}
class MedicCloseDatePickerState extends MedicState{}


