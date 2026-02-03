part of 'app_startup_bloc.dart';

@immutable
sealed class AppStartupState {}

final class AppStartupInitial extends AppStartupState {}

class AppStartupLoadingState extends AppStartupState{}
class AppStartupErrorState extends AppStartupState{
  final String errorMessage;
  AppStartupErrorState(this.errorMessage);
}
class AppStartupSuccessState extends AppStartupState{
  final String role;
  AppStartupSuccessState(this.role);
}
