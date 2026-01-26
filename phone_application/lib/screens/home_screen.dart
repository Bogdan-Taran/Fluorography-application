import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/bloc/curator/curator_bloc.dart';
import 'package:project_fluorography/bloc/medic/medic_bloc.dart';
import 'package:project_fluorography/screens/curator_screen.dart';
import 'package:project_fluorography/screens/medic_screen.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import 'package:project_fluorography/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/admin/admin_bloc.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../services/shared_pref_service.dart';
import '../styles.dart';
import 'admin_screen.dart';

class HomeScreen extends StatelessWidget {
  static String id = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyles _textStyles = TextStyles();
    final AuthService _authService = AuthService();
    final prefs = SharedPreferences.getInstance();
    final UserSharedPreferences _userSharedPreferences =
    UserSharedPreferences();

    return FutureBuilder<String>(
      future: _userSharedPreferences.getUserRole(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          String role = snapshot.data!;

          if (role == 'curator') {
            print('Ваша роль куратор');
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => CuratorBloc(),
                ),
                BlocProvider(
                  create: (context) => AuthenticationBloc(),
                ),
                BlocProvider(
                  create: (context) => SearchBloc(),
                ),
              ],
              child: CuratorScreen(),
            );
          } else if (role == 'admin') {
            print('Ваша роль администратор');
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AdminBloc(),
                ),
                BlocProvider(
                  create: (context) => AuthenticationBloc(),
                ),
              ],
              child: AdminScreen(),
            );
          } else if (role == 'medic') {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => MedicBloc(),
                ),
                BlocProvider(
                  create: (context) => AuthenticationBloc(),
                ),
                BlocProvider(
                  create: (context) => SearchBloc(),
                ),
                BlocProvider(
                  create: (context) => WorkingWithFluorographyBloc(),
                ),
              ],
              child: MedicScreen(),
            );
          } else {
            try {
              print('Ваша роль $role');
            } on Exception catch (_) {
              print('Произошла непон ошибка');
            }
          }
          return Scaffold(
            body: Center(
              child: Text(
                'Ваша роль $role дада',
                style: _textStyles.textStyleTitle(context),
              ),
            ),
          );
        } else {
          print('Данные не загружаются');
          return LoadingAnimationWidget.halfTriangleDot(
            color: Colors.white,
            size: 24,
          );
        }
      },
    );
  }
}
