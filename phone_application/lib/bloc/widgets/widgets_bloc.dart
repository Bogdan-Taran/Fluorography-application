import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'widgets_event.dart';
part 'widgets_state.dart';

class WidgetsBloc extends Bloc<WidgetsEvent, WidgetsState> {
  WidgetsBloc() : super(WidgetsInitial()) {
    on<WidgetsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
