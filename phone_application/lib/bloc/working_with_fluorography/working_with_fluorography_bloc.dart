import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';

part 'working_with_fluorography_event.dart';
part 'working_with_fluorography_state.dart';

class WorkingWithFluorographyBloc extends Bloc<WorkingWithFluorographyEvent, WorkingWithFluorographyState> {
  WorkingWithFluorographyBloc() : super(WorkingWithFluorographyInitial()) {
    on<WorkingWithFluorographyEvent>((event, emit) {});


  }
}
