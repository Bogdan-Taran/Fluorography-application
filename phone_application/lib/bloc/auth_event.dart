part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String login;
  final String password;

  LoginRequested({required this.login, required this.password});
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class LoadProfileFromToken extends AuthEvent {}