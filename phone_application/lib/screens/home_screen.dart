import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import 'package:project_fluorography/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/shared_pref_service.dart';
import '../styles.dart';

class HomeScreen extends StatelessWidget{
  static String id = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    TextStyles textStyles = TextStyles();
    AuthService _authService = AuthService();
    final prefs = SharedPreferences.getInstance();
    UserSharedPreferences _userSharedPreferences = UserSharedPreferences();
    // final String role =  await _userSharedPreferences.getUserRole();



    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello, user, your role iS:',
              // style: textStyles.textStyleTitle(context),
            ),
            FutureBuilder<String>(
              future: _userSharedPreferences.getUserRole(),
              builder: (context, AsyncSnapshot<String> snapshot){
                if(snapshot.hasData){
                  String role = snapshot.data!;
                  return Text(
                    'Your role is $role',
                    style: textStyles.textStyleTitle(context),
                  );
                } else{
                  return LoadingAnimationWidget.halfTriangleDot(
                    color: Colors.white,
                    size: 24,);
                }
              },
            ),

            const SizedBox(
              height: 20,
            ),

            BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if(state is AuthenticationLoadingState){
                  const CircularProgressIndicator();
                }
                else if(state is AuthenticationLogOutState){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {return SignInScreen();}));
                }
                else if(state is AuthenticationFailureState){
                  showDialog(
                    context: context,
                    builder: (context){
                      return const AlertDialog(
                        content: Text('Error'),
                      );
                    }
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                    onPressed: () {
                      // context.read<AuthenticationBloc>().add(const SignOutEvent());
                      BlocProvider.of<AuthenticationBloc>(context).add(SignOutEvent());
                    },
                    child: Text(
                      'Выйти'
                    ),
                );
              },
            ),
            ElevatedButton(
                onPressed: _userSharedPreferences.getUserFirstnameFromSharedPreferences,
                child: Text('Print your id in console')
            )
          ],
        ),
      ),
    );
  }
}
