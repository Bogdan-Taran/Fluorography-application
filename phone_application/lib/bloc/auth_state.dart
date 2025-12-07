part of 'auth_bloc.dart';
// import '/models/user_models.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated({required this.user});
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthLogoutLoading extends AuthState {}


