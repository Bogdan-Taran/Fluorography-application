import 'package:bloc/bloc.dart';
import 'package:project_fluorography/services/auth_service.dart';

import '../../models/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService = AuthService();

  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});

    on<SignInUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
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
      emit(AuthenticationLoadingState(isLoading: true));
    });

    on<SignOut>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try{
        authService.signOutUser();
      }
      catch (e){
        print('error');
        print(e.toString());
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });
  }
}
