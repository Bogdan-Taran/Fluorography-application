part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();
  List<Object> get props => [];
}

class IsAuthenticatedCheckEvent extends AuthenticationEvent{}

class SignInUserEvent extends AuthenticationEvent{
  final String login;
  final String password;

  const SignInUserEvent(this.login, this.password);

  @override
  List<Object> get props => [login, password];
}

class SignOutEvent extends AuthenticationEvent{
  const SignOutEvent();

  @override
  List<Object> get props => throw UnimplementedError();
}


