part of 'medic_bloc.dart';

@immutable
abstract class MedicEvent {
  const MedicEvent();
}

// api
class MedicInitialEvent extends MedicEvent{}
class MedicFetchEvent extends MedicEvent{}

// authentication
class MedicLogoutEvent extends MedicEvent{}

//date change
class MedicOpenDatePickerEvent extends MedicEvent{}
class MedicCloseDatePickerEvent extends MedicEvent{}
class MedicSelectDateEvent extends MedicEvent{
  final String selectedDate;
  const MedicSelectDateEvent({
    required this.selectedDate,
  });
}

//search
class OnTapTextFieldEvent extends MedicEvent{}
class SearchChangedMedicEvent extends MedicEvent{
  final String query;
  final List<StaffAndStudentsModel>? entireGroups;
  SearchChangedMedicEvent({required this.query, this.entireGroups});
}
// class OnTapOutsideTextFieldMedicEvent extends MedicEvent{}

// local cache storage
class MedicFetchedNewDateSetEvent extends MedicEvent{
  final Map<String, String> newDateSet;
  MedicFetchedNewDateSetEvent({required this.newDateSet});
  List<Object> get props => [newDateSet];
}

