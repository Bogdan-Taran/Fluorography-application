import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/bloc/internet_connect/interner_connect_cubit.dart';
import 'package:project_fluorography/bloc/medic/medic_bloc.dart';
import 'package:project_fluorography/bloc/navigation/navigation_bloc.dart';
import 'package:project_fluorography/screens/home_screen.dart';
import 'package:project_fluorography/screens/medic_screen.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import 'package:project_fluorography/services/auth_service.dart';
import 'package:project_fluorography/services/builders_screen.dart';
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
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light
  ));

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
                title: 'Flura',
                theme: ThemeData(
                  appBarTheme: AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarBrightness: Brightness.light
                    )

                  )
                ),
                home: AuthChecker(),
                // home: MedicScreen(),
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
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(IsAuthenticatedCheckEvent());
  }

  @override
  Widget build(BuildContext context) {
    BuildersScreen _BuildersScreen = BuildersScreen();
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state){
        switch(state.runtimeType){
          case AuthenticationLoadingState:
            _BuildersScreen.buildLoading();
          case NotAuthenticatedState:
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                    BlocProvider(create: (context) => InternetConnectCubit(connectivity: Connectivity()),
        child: SignInScreen())
                       // HomeScreen()
                ));
          case AuthorizedState:
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        HomeScreen()));
          default:
            _BuildersScreen.buildLoading();
        }
      },
      child: SizedBox(height: 0,),
    );

  }
}
