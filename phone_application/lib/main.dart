import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_fluorography/screens/roles_depend_screen/medic/screens/medic_screen.dart';
import 'package:project_fluorography/services/auth_service.dart';
import 'package:project_fluorography/widgets/auth_wrapper.dart';
import '/screens/login.dart';
import 'package:flutter/services.dart';

import 'bloc/auth_bloc.dart';

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
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(authService: AuthService()))
        ],
        child: MaterialApp(
          title: 'Флюорография',
          theme: ThemeData(
            primarySwatch: Colors.blue
          ),
          home: const StartupScreen(),
          debugShowCheckedModeBanner: false,
        )
    );

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   // home: Login(),
    //   home: MedicScreen(),
    // );
  }
}







