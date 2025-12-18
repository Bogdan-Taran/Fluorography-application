part of 'navigation_bloc.dart';

@immutable
abstract class NavigationState {}

final class NavigationInitial extends NavigationState {}

class LoginPageState extends NavigationState{}

class HomePageState extends NavigationState{}

class CuratorPageState extends NavigationState{}
