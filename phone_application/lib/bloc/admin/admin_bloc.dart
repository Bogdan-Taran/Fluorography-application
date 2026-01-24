import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(AdminInitial()) {
    on<AdminInitialEvent>(adminInitialEvent);
  }

  FutureOr<void> adminInitialEvent(AdminInitialEvent event, Emitter<AdminState> emit) {

  }
}
