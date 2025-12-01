import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../services/auth_service.dart' hide User;
import '../models/user_models.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final user = await _authService.login(event.login, event.password);
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await _authService.logout();
    emit(AuthInitial());
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event,
      Emitter<AuthState> emit,
      ) async {
    final token = await _authService.getAuthToken();
    if (token != null) {
      // Тут можно загрузить профиль пользователя
      emit(AuthInitial()); // или Authenticated с загрузкой профиля
    } else {
      emit(AuthInitial());
    }
  }
}