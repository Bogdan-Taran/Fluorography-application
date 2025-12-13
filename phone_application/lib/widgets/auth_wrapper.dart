import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../screens/login.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../services/auth_service.dart';
import '../models/user_models.dart';
import '../screens/role_screens.dart';


class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          // Если пользователь вышел, перенаправляем на логин
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Показываем анимацию загрузки при logout
          if (state is AuthLogoutLoading) {
            return Scaffold(
              body: Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: const Color(0xff98BFF3),
                  size: 60,
                ),
              ),
            );
          }

          // Иначе показываем основной контент
          return child;
        },
      ),
    );
  }
}


// Новый виджет для проверки токена при запуске
class StartupScreen extends StatefulWidget {
  const StartupScreen({Key? key}) : super(key: key);

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}


class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authService = AuthService();
    final hasToken = await authService.hasSavedCredentials();

    if (hasToken) {
      final isValid = await authService.isTokenValid();
      if (isValid) {
        // Если токен валидный, отправляем событие для загрузки профиля
        context.read<AuthBloc>().add(LoadProfileFromToken());
        // И перенаправляем на главный экран, где BlocListener будет следить за состоянием
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const _AuthCheckingScreen()),
        );
      }
      else {
        // Если токен не валидный, перенаправляем на логин
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      // Если токена нет, перенаправляем на логин
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.halfTriangleDot(
          color: const Color(0xff98BFF3),
          size: 60,
        ),
      ),
    );
  }
}




// Вспомогательный экран для проверки аутентификации
class _AuthCheckingScreen extends StatelessWidget {
  const _AuthCheckingScreen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Если пользователь аутентифицирован, перенаправляем на главный экран
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToRoleScreen(context, state.user);
          });
        } else if (state is AuthInitial) {
          // Если не аутентифицирован, перенаправляем на логин
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: LoadingAnimationWidget.halfTriangleDot(
            color: const Color(0xff98BFF3),
            size: 60,
          ),
        ),
      ),
    );
  }

  void _navigateToRoleScreen(BuildContext context, User user) {
    Widget screen;

    switch (user.userRole) {
      case UserRole.medic:
        screen = const MedicScreen();
        break;
      case UserRole.curator:
        if (user.curatorGroups != null) {
          screen = CuratorScreen(groupNumber: user.curatorGroups);
        }
        else {
          screen = const MedicScreen();
        }
        break;
      case UserRole.administrator:
        screen = const AdminScreen();
        break;
      case UserRole.student:
      case UserRole.employee:
        screen = const MedicScreen();
        break;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => screen),
    );


  }
}