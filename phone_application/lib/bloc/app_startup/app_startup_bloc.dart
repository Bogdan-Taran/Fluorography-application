import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../services/shared_pref_service.dart';

part 'app_startup_event.dart';
part 'app_startup_state.dart';

class AppStartupBloc extends Bloc<AppStartupEvent, AppStartupState> {
  UserSharedPreferences _userSharedPreferences = UserSharedPreferences();
  AppStartupBloc() : super(AppStartupInitial()) {
    on<AppStartUpInitEvent>(appStartUpInitEvent);
  }

  FutureOr<void> appStartUpInitEvent(AppStartUpInitEvent event, Emitter<AppStartupState> emit) async {
    emit(AppStartupLoadingState());
    try{
      final role = await _userSharedPreferences.getUserRole();
      if(role.isNotEmpty || role != null){
        emit(AppStartupSuccessState(role));
      }else{
        emit(AppStartupErrorState('Отсутствует роль'));
      }
    }
    catch (e){
      emit(AppStartupErrorState('Произошла ошибка при попытке получить роль'));
    }
  }
}
