import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';

part 'working_with_fluorography_event.dart';
part 'working_with_fluorography_state.dart';

class WorkingWithFluorographyBloc extends Bloc<WorkingWithFluorographyEvent, WorkingWithFluorographyState> {
  WorkingWithFluorographyBloc() : super(WorkingWithFluorographyState()) {
    on<TurnOnEditingModeEvent>(turnOnEditingModeEvent);
    on<CancelEditingModeEvent>(cancelEditingModeEvent);
    on<EnableEditingModeEvent>(enableEditingModeEvent);
    on<OpenDatePickerEvent>(openDatePickerEvent);
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
    emit(state.copyWith(editingStates: newStates));
    // emit(CancelEditModeWorkingWithFluorographyState());
  }

  FutureOr<void> enableEditingModeEvent(EnableEditingModeEvent event, Emitter<WorkingWithFluorographyState> emit) {
    // loading
    // api call

    // success:
    emit(EnableEditModeWorkingWithFluorographyState());

  //   error:
  //   ErrorState
  }

  FutureOr<void> openDatePickerEvent(OpenDatePickerEvent event, Emitter<WorkingWithFluorographyState> emit) {
    emit(OpenedDatePickerState());
  }
}


class SelectDateBloc extends Bloc<SelectDateEvent, SelectDateState>{
  SelectDateBloc(): super(SelectDateState()){
    // on<SelectDateEvent>
    //     (event, emit) => emit(state.copyWith(selectedDate: event.selectedDate));
  }
}

