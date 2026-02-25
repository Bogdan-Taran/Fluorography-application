import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:project_fluorography/services/auth_service.dart';
import 'package:talker/talker.dart';

import '../../models/user_model.dart';
import '../../services/localDataBase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService = AuthService();
  CacheService _CacheService = CacheService();
  final talker = Talker();

  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});
    on<IsAuthenticatedCheckEvent>(isAuthenticatedCheckEvent);
    on<SignOutEvent>(signOutEvent);
    on<SignOutAcceptEvent>(signOutAcceptEvent);
    on<SignOutCancelEvent>(signOutCancelEvent);

    on<SignInUserEvent>(signInUserEvent);

  }
  FutureOr<void> isAuthenticatedCheckEvent(IsAuthenticatedCheckEvent event, Emitter<AuthenticationState> emit) async{
    emit(AuthenticationLoadingState());
    bool isAuthenticatedHasToken = await authService.hasAuthToken();
    isAuthenticatedHasToken ? emit(AuthorizedState()) : emit(NotAuthenticatedState());

  }
  FutureOr<void> signOutEvent(SignOutEvent event, Emitter<AuthenticationState> emit) {
    emit(HasAcceptedLogOutState());
  }
  FutureOr<void> signOutAcceptEvent(SignOutAcceptEvent event, Emitter<AuthenticationState> emit) async{
    //TODO убрал async на время тестов
    emit(AuthenticationLoadingState());
    try{
      await authService.signOutUser();
      await _CacheService.removeFromCache('groups_data');
      emit (AuthenticationLogOutState(isLoading: false, successful: true));
    }
    catch (e){
      print('error while logout');
      print(e.toString());
    }
    emit(AuthenticationLogOutErrorState());
  }

  FutureOr<void> signOutCancelEvent(SignOutCancelEvent event, Emitter<AuthenticationState> emit) {
    emit(OnCancelLogOutState());
  }

  FutureOr<void> signInUserEvent(SignInUserEvent event, Emitter<AuthenticationState> emit) async{
    emit(AuthenticationLoadingState());
    try{
      final resultLogin = await authService.signInUser(event.login, event.password);
      resultLogin.fold(
          (error){
            talker.error('AuthBloc: Возникла ошибка при попытке залогиниться: ${error['data']}');
            emit(AuthenticationFailureState(
                errorMessage: error['data'],
              statusCode: error['statusCode']
            ));
          },
          (user){
            emit(AuthenticationSuccessAfterLoginState(user!));
          }
      );
    }
    catch (e) {
      print(e.toString());
    }
    // emit(AuthenticationLoadingState());
  }
}
