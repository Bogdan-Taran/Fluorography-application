part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();
  List<Object> get props => [];
}

class SignInUser extends AuthenticationEvent{
  final String login;
  final String password;

  const SignInUser(this.login, this.password);

  @override
  List<Object> get props => [login, password];
}

class SignOut extends AuthenticationEvent{}


