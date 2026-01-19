part of 'medic_bloc.dart';

@immutable
abstract class MedicState {}

abstract class MedicActionState extends MedicState{}

final class MedicInitial extends MedicState {}

class MedicFetchingLoadingState extends MedicState{}
class MedicLoadedCommunitySuccessfulState extends MedicState{
  final List<StaffAndStudentsModel> medicEntireCommunity;

  MedicLoadedCommunitySuccessfulState({required this.medicEntireCommunity});
}
class MedicFetchingErrorState extends MedicState{}
