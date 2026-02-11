import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';

import '../../services/api_service.dart';

part 'working_with_fluorography_event.dart';
part 'working_with_fluorography_state.dart';

class WorkingWithFluorographyBloc extends Bloc<WorkingWithFluorographyEvent, WorkingWithFluorographyState> {
  ApiService _ApiService = ApiService();
  WorkingWithFluorographyBloc() : super(WorkingWithFluorographyState()) {
    on<TurnOnEditingModeEvent>(turnOnEditingModeEvent);
    on<CancelEditingModeEvent>(cancelEditingModeEvent);
    on<OpenDatePickerEvent>(openDatePickerEvent);
    on<CloseDatePickerEvent>(closeDatePickerEvent);
    on<SelectDateEvent>(selectDateEvent);
    on<SaveEditingModeEvent>(saveEditingModeEvent);
  }


  FutureOr<void> turnOnEditingModeEvent(TurnOnEditingModeEvent event, Emitter<WorkingWithFluorographyState> emit) {
    final newStates = Map<String, bool>.from(state.editingStates);
    newStates[event.uniqueId] = true;
    emit(state.copyWith(editingStates: newStates));
    // emit(EditModeWorkingWithFluorographyState());
  }


  FutureOr<void> cancelEditingModeEvent(CancelEditingModeEvent event, Emitter<WorkingWithFluorographyState> emit) {
    final newStates = Map<String, bool>.from(state.editingStates);
    newStates[event.uniqueId] = false;
    emit(state.copyWith(tempDates: {}));
    emit(state.copyWith(editingStates: newStates));
    // emit(CancelEditModeWorkingWithFluorographyState());
  }
  FutureOr<void> openDatePickerEvent(OpenDatePickerEvent event, Emitter<WorkingWithFluorographyState> emit) {
    // emit(OpenedDatePickerState());
    final newStates = Map<String, bool>.from(state.editingStates);
    newStates[event.uniqueId] = true;
    emit(state.copyWith(editingStates: newStates));
  }
  FutureOr<void> closeDatePickerEvent(CloseDatePickerEvent event, Emitter<WorkingWithFluorographyState> emit) {
    final newStates = Map<String, bool>.from(state.editingStates);
    newStates[event.uniqueId] = false;
    emit(state.copyWith(editingStates: newStates));
  }

  FutureOr<void> selectDateEvent(SelectDateEvent event, Emitter<WorkingWithFluorographyState> emit) {
    final isCurrentlyEditing = state.editingStates[event.uniqueContainerId] ?? false;
    print('Пришло событие выбора даты, состояение измеенния: $isCurrentlyEditing');
    if(isCurrentlyEditing){
      final newTempDates = Map<String, String>.from(state.tempDates);
      newTempDates[event.uniqueContainerId] = event.selectedDate;
      print('Bloc. Изменяю дату (${event.selectedDate}) для ${event.uniqueContainerId}');
      emit(state.copyWith(tempDates: newTempDates));
    }
  }

  Future<void> saveEditingModeEvent(SaveEditingModeEvent event, Emitter<WorkingWithFluorographyState> emit) async {
    final newDatesPatch = state.tempDates;
    print('Даты котрые будут изменены: $newDatesPatch');
    final result = await _ApiService.updateFluraDateFromSet(newDatesPatch);
    emit(state.copyWith(tempDates: {}));

    if(result['success']){
      emit(SuccessfullyPatchedSetDatesState(newDateSet: newDatesPatch));
    } else{
      emit(FailToPatchDatesState());
    }

  }

}


// class SelectDateBloc extends Bloc<SelectDateEvent, SelectDateState>{
//   SelectDateBloc(): super(SelectDateState()){
//     // on<SelectDateEvent>
//     //     (event, emit) => emit(state.copyWith(selectedDate: event.selectedDate));
//   }
// }

