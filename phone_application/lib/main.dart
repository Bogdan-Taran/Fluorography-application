import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/bloc/internet_connect/interner_connect_cubit.dart';
import 'package:project_fluorography/screens/redirect_screen.dart';
import 'package:project_fluorography/screens/reference/reference_screen.dart';
import 'package:project_fluorography/screens/secretary/secretary_screen_main.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import 'package:project_fluorography/services/builders_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/styles/themes/AppInputDecoration.dart';

import 'notifications/notification_service.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //init notifications
  NotificationService().initNotification();

  //установка только портретной ориентации
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );




  runApp(
      const ProviderScope(child: MyApp())
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider<InternetConnectCubit>(
          create: (context) => InternetConnectCubit(connectivity: Connectivity()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flura',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
            ),
          ),
          inputDecorationTheme: AppInputDecorations.theme,

        ),
         home: AuthChecker(),
        //home: SecretaryScreen(),
      ),
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
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case AuthenticationLoadingState:
              _BuildersScreen.buildLoading();

            /*case NotAuthenticatedState:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider(
                    create: (context) =>
                        InternetConnectCubit(connectivity: Connectivity()),
                    child: SignInScreen(),
                  ),
                  // HomeScreen()
                ),
              );*/
            case NotAuthenticatedState:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider(
                    create: (context) =>
                        InternetConnectCubit(connectivity: Connectivity()),
                    child: ReferenceScreen(),
                  ),
                  // HomeScreen()
                ),
              );
            case AuthorizedState:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(),
                ),
              );
            default:
              _BuildersScreen.buildLoading();
          }
        },
        child: CircularProgressIndicator()
      ),
    );
  }
}
