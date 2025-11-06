// Перехватывает инициированное событие с указанием состояния
// (например, «привет» или «еда» в демонстрационном видео) и обновляет состояние.



import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


part 'medic_state.dart';
part 'medic_event.dart';

class MedicBloc extends Bloc<MedicEvent, MedicState> {
  MedicBloc() : super(MedicInitial()) {

  }

}
