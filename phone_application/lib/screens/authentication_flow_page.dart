import 'package:flutter/material.dart';
import 'package:project_fluorography/services/auth_service.dart';

class AuthenticationFlowScreen extends StatelessWidget{
  const AuthenticationFlowScreen({super.key});
  static String id = 'main screen';
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _authService.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return const HomeScreen();
            }
            else{
              return const SignInScreen();
            }
          }
      ),
    );
  }
}