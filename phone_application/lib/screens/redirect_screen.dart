import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/bloc/app_startup/app_startup_bloc.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/bloc/curator/curator_bloc.dart';
import 'package:project_fluorography/bloc/internet_connect/interner_connect_cubit.dart';
import 'package:project_fluorography/bloc/medic/medic_bloc.dart';
import 'package:project_fluorography/screens/curator/curator_screen_main.dart';
import 'package:project_fluorography/screens/medic/medic_screen_main.dart';
import 'package:project_fluorography/screens/secretary/secretary_screen_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/admin/admin_bloc.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../services/builders_screen.dart';
import '../services/shared_pref_service.dart';
import '../styles.dart';
import 'admin/admin_screen_main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BuildersScreen _buildersScreen = BuildersScreen();


    return BlocProvider(
        create: (context) => AppStartupBloc()..add(AppStartUpInitEvent()),
      child: BlocBuilder<AppStartupBloc, AppStartupState>(
        builder: (context, state){
          if(state is AppStartupLoadingState){
            return Scaffold(
              body: _buildersScreen.buildLoading(),
            );
          }
          else if(state is AppStartupSuccessState){
            String role = state.role;

            if (role == 'curator') {
              print('Ваша роль куратор');
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => CuratorBloc(),),
                  // BlocProvider(create: (context) => AuthenticationBloc(),),
                  BlocProvider(create: (context) => SearchBloc(),),
                  BlocProvider(create: (context) => WorkingWithFluorographyBloc(),),
                  BlocProvider(create: (_) => InternetConnectCubit(connectivity: Connectivity()),)
                ],
                child: const CuratorScreen(),
              );
            }
            else if (role == 'admin') {
              print('Ваша роль администратор');
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => AdminBloc(),),
                  BlocProvider(create: (context) => AuthenticationBloc(),),
                  BlocProvider(create: (context) => WorkingWithFluorographyBloc(),),
                  BlocProvider(create: (_) => InternetConnectCubit(connectivity: Connectivity()),)
                ],
                child: const AdminMainScreen(),
              );
            } else if (role == 'medic') {
              print('Ваша роль медик');
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => MedicBloc(),),
                  /*
                BlocProvider(
                  create: (context) => AuthenticationBloc(),
                ),
                */
                  BlocProvider(create: (context) => SearchBloc(),),
                  BlocProvider(create: (context) => WorkingWithFluorographyBloc(),),
                  BlocProvider(create: (_) => InternetConnectCubit(connectivity: Connectivity()),)
                ],
                child: MedicScreen(),
              );
            }
            else if (role == 'secretary') {
              print('Ваша роль секретарь');
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => SearchBloc(),),
                  BlocProvider(create: (context) => WorkingWithFluorographyBloc(),),
                  BlocProvider(create: (_) => InternetConnectCubit(connectivity: Connectivity()),)
                ],
                child: SecretaryScreen(),
              );
            }
            else{
              print('У вас неизвестная роль');
              return Center(
                child: Text(
                  'Лягушка Неизвестная роль: $role',
                  style: TextStyle(fontSize: AppStyle.fontSizeMedium_16),
                ),
              );
            }
          }
          else if(state is AppStartupErrorState){
            return Scaffold(
              body: Center(
                child: Text(
                  state.errorMessage,
                  style: TextStyle(fontSize: AppStyle.fontSizeMedium_16),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: _buildersScreen.buildLoading(),
            ),
          );
        },
      ),
    );


/*    return FutureBuilder<String>(
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
                // BlocProvider(
                //   create: (context) => AuthenticationBloc(),
                // ),
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
                // BlocProvider(
                //   create: (context) => AuthenticationBloc(),
                // ),
              ],
              child: AdminScreen(),
            );
          } else if (role == 'medic') {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => MedicBloc(),
                ),

                // BlocProvider(
                //   create: (context) => AuthenticationBloc(),
                // ),

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
    );*/
  }
}
