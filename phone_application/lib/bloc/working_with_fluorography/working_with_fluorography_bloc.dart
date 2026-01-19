import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';

part 'working_with_fluorography_event.dart';
part 'working_with_fluorography_state.dart';

class WorkingWithFluorographyBloc extends Bloc<WorkingWithFluorographyEvent, WorkingWithFluorographyState> {
  WorkingWithFluorographyBloc() : super(WorkingWithFluorographyInitial()) {
    on<WorkingWithFluorographyEvent>((event, emit) {});
    on<LoadCuratorGroupsEvent>((event, emit){

    });
    // on<UpdateFluorographyDateEvent>(onUpdateFluorographyDateEvent);
    //on<CancelEditingModeEvent>(onCancelEditingModeEvent);
    // on<EnableEditingModeEvent>(onEnableEditingModeEvent);
  }

  Future<void> onUpdateFluorographyDateEvent(UpdateFluorographyDateEvent event, Emitter<WorkingWithFluorographyState> emit) async{

  }

  Future<void> onCancelEditingModeEvent () async {}

}

class SelectDateBloc extends Bloc<SelectDateEvent, SelectDateState>{
  SelectDateBloc(): super(const SelectDateState()){
    on<SelectDateEvent>
        (event, emit) => emit(state.copyWith(selectedDate: event.selectedDate));
  }
}
