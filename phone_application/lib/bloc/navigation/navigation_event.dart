part of 'navigation_bloc.dart';


abstract class NavigationEvent {
  const NavigationEvent();
  List<Object> get props => [];
}

class AppStartedEvent extends NavigationEvent{
  const AppStartedEvent();
  List<Object> get props => [];
}
class AppNavigateToLoginPageEvent extends NavigationEvent{
  const AppNavigateToLoginPageEvent();
  List<Object> get props => [];
}

class AppNavigateToCuratorPageEvent extends NavigationEvent{
  const AppNavigateToCuratorPageEvent();
  List<Object> get props => [];
}
class AppNavigateToMedicPageEvent extends NavigationEvent{
  const AppNavigateToMedicPageEvent();
  List<Object> get props => [];
}
class AppNavigateToAdminPageEvent extends NavigationEvent{
  const AppNavigateToAdminPageEvent();
  List<Object> get props => [];
}