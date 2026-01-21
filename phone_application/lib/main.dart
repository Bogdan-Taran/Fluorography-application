import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/bloc/medic/medic_bloc.dart';
import 'package:project_fluorography/bloc/navigation/navigation_bloc.dart';
import 'package:project_fluorography/screens/home_screen.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import 'package:project_fluorography/services/auth_service.dart';
import 'package:project_fluorography/services/shared_pref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/curator/curator_bloc.dart';
import 'bloc/working_with_fluorography/working_with_fluorography_bloc.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //установка только портретной ориентации
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<AuthenticationBloc>(
                  create: (context) => AuthenticationBloc(),
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Clean Flura',
                home: AuthChecker(),
              ),
            );
          },
        );
      },
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isAuthenticated = false;
  bool _isLoading = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    bool hasToken = await _authService.hasAuthToken();
    setState(() {
      _isAuthenticated = hasToken;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _isAuthenticated ? HomeScreen() : SignInScreen();
  }
}
