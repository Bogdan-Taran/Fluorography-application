import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import 'package:project_fluorography/services/auth_service.dart';

import 'home_screen.dart';

class AuthenticationFlowScreen extends StatelessWidget{
  AuthenticationFlowScreen({super.key});
  static String id = 'main_screen';
  final AuthService _authService = AuthService();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _controller.stream,
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