part of 'medic_bloc.dart';

@immutable
abstract class MedicEvent {
  const MedicEvent();
}

class MedicInitialEvent extends MedicEvent{}

class MedicLogoutEvent extends MedicEvent{}

class MedicOpenDatePickerEvent extends MedicEvent{}
class MedicCloseDatePickerEvent extends MedicEvent{}
class MedicSelectDateEvent extends MedicEvent{
  final String selectedDate;
  const MedicSelectDateEvent({
    required this.selectedDate,
  });
}

class OnTapTextFieldEvent extends MedicEvent{}
class OnChangedSearchTextEvent extends MedicEvent{
  final String query;
  OnChangedSearchTextEvent({required this.query});
}

class MedicFetchedNewDateSetEvent extends MedicEvent{
  final Map<String, String> newDateSet;
  MedicFetchedNewDateSetEvent({required this.newDateSet});
  List<Object> get props => [newDateSet];
}

