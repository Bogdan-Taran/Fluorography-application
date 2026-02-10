import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:project_fluorography/services/auth_service.dart';

import '../../models/user_model.dart';
import '../../services/localDataBase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService = AuthService();
  CacheService _CacheService = CacheService();

  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});
    on<IsAuthenticatedCheckEvent>(isAuthenticatedCheckEvent);
    on<SignOutEvent>(signOutEvent);
    on<SignOutAcceptEvent>(signOutAcceptEvent);

    on<SignInUserEvent>((event, emit) async {
      emit(AuthenticationLoadingState());
      try{
        final UserData? user = await authService.signInUser(event.login, event.password);
        if (user != null){
          emit(AuthenticationSuccessAfterLoginState(user));
        }
        else{
          emit(const AuthenticationFailureState(errorMessage: 'Login user falied'));
        }
      }
      catch (e) {
        print(e.toString());
      }
      // emit(AuthenticationLoadingState());
    });
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
}
