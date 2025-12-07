import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../screens/login.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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