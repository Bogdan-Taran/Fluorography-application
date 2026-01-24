import 'package:bloc/bloc.dart';
import 'package:project_fluorography/services/auth_service.dart';

import '../../models/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService = AuthService();

  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});

    on<SignInUserEvent>((event, emit) async {
      emit(AuthenticationLoadingState());
      try{
        final UserData? user = await authService.signInUser(event.login, event.password);
        if (user != null){
          emit(AuthenticationSuccessState(user));
        }
        else{
          emit(const AuthenticationFailureState(errorMessage: 'Login user falied'));
        }
      }
      catch (e) {
        print(e.toString());
      }
      emit(AuthenticationLoadingState());
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthenticationLoadingState());
      try{
        await authService.signOutUser();
        emit (AuthenticationLogOutState(isLoading: false, successful: true));
      }
      catch (e){
        print('error while logout');
        print(e.toString());
      }
      emit(AuthenticationLoadingState());
    });
  }
}
