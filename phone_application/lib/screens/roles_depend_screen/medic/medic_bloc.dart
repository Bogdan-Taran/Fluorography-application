// Перехватывает инициированное событие с указанием состояния
// (например, «привет» или «еда» в демонстрационном видео) и обновляет состояние.



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_fluorography/screens/roles_depend_screen/medic/medic_event.dart';

import 'medic_state.dart';

class MedicBloc extends Bloc<MedicEvent, MedicState>
{
  MedicBloc():super(MedicInitialState())
  {
    on<MedicIncrementEvent>((event, emit) {
      emit(MedicIncrementState(state.counter+1));
    });
    on<MedicDecrementEvent>((event, emit) {
      emit(MedicDecrementState(state.counter-1));
    });
  }
}
