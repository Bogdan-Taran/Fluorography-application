part of 'authentication_bloc.dart';


abstract class AuthenticationState {
  const AuthenticationState();
  //метод props возвращает спиоск объектов (для проверки на равеснтво)
  List<Object> get props => [];
}

//инициализация состояния - начальное состояние процесса аутентификации
class AuthenticationInitialState extends AuthenticationState {}

//состояние загрузки
class AuthenticationLoadingState extends AuthenticationState{
  final bool isLoading;

  AuthenticationLoadingState(this.isLoading);
}

//успешная авторизация
class AuthenticationSuccessState extends AuthenticationState{
  final UserData user;

  const AuthenticationSuccessState(this.user);
  @override
  List<Object> get props => [user];
}

//неудачная авторизация
class AuthenticationFailureState extends AuthenticationState{
  final String errorMessage;

  const AuthenticationFailureState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

//выход
class AuthenticationLogOutState extends AuthenticationState{
  final bool isLoading;
  final bool successful;

  AuthenticationLogOutState({required this.isLoading, required this.successful});
  List<Object> get props => [];
}

