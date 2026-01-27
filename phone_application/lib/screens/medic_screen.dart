import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/bloc/medic/medic_bloc.dart';
import 'package:project_fluorography/bloc/search/search_bloc.dart';
import 'package:project_fluorography/models/staff_and_students_model.dart';
import 'package:project_fluorography/screens/sign_in.dart';

import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../services/builders_screen.dart';
import '../services/shared_pref_service.dart';
import '../styles.dart';
import '../widgets/accordion_widgets.dart';
import '../widgets/main_content_accordion_builder.dart';
import '../widgets/screens_widgets.dart';

class MedicScreen extends StatefulWidget {
  static String id = 'medic_screen';

  const MedicScreen({super.key});

  @override
  State<MedicScreen> createState() => _MedicScreen();
}

class _MedicScreen extends State<MedicScreen> {
  @override
  void initState() {
    (context).read<MedicBloc>().add(MedicInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BuildersScreen _buildersScreen = BuildersScreen();
    ScreensWidgets _ScreensWidgets = ScreensWidgets();

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.lightBlueAccent,
        appBar: _ScreensWidgets.AppBarFlura(
          context: context,
          bloc: context.read<AuthenticationBloc>(),
          event: SignOutEvent(),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: MultiBlocListener(
                  listeners: [
                    BlocListener<MedicBloc, MedicState>(
                        listener: (context, state) {
                          switch (state.runtimeType) {
                            case MedicLogoutSuccessfulState:
                              print('Отработало сосотояния выхода');
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SignInScreen()));
                              break;
                            case MedicLogoutErrorState:
                              print('Ошибка при попытке выхода');
                              break;
                            case MedicFetchingLoadingState:
                              _buildersScreen.buildLoading();
                              print('Загрузка выхода');
                              break;

                            // case MedicOpenDatePickerState:
                            //   _buildersScreen.openDatePicker(context, );
                            //   break;
                            // case MedicCloseDatePickerState:
                            //   Navigator.of(context).pop();
                          }
                        }),
                    BlocListener<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) {
                        switch (state.runtimeType) {
                          case AuthenticationLogOutState:
                            print('Отработало сосотояния выхода');
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SignInScreen(),
                              ),
                            );
                            break;
                          case AuthenticationLoadingState:
                            print('Загрузка');
                            _buildersScreen.buildLoading();
                            break;
                        }
                      },
                    ),
                  ],
                  child: BlocBuilder<MedicBloc, MedicState>(
                    builder: (context, medicState) {
                          switch (medicState.runtimeType) {
                            case MedicFetchingLoadingState:
                              return Center(
                                  child: _buildersScreen.buildLoading());
                            case MedicFetchingErrorState:
                              return Center(child: Text('Произошла ошибка'));

                            case MedicLoadedCommunitySuccessfulState:
                              final successfulState =
                              medicState as MedicLoadedCommunitySuccessfulState;
                              print('Печатаю лист');
                              print(successfulState.medicEntireCommunity);
                              return MainContentAccordionBuilder(
                                context, role: 'medic',
                                medicEntireCommunity: successfulState
                                    .medicEntireCommunity,);


                            default:
                              return Container(
                                padding: EdgeInsetsGeometry.symmetric(
                                    horizontal: 15),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 1,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.8,
                                decoration: BoxDecoration(
                                    color: Colors.transparent),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'У вас отсутствуют какие-либо люди в списках. Сисимасиси',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    ElevatedButton(onPressed: () {
                                      context.read<MedicBloc>().add(
                                          MedicOpenDatePickerEvent());
                                      print('Нажата кнопка выбора даты');
                                    }, child: Text('Выбор даты'))
                                  ],
                                ),
                              );
                          }
                        },

                  )
              )


          ),
        ),
      ),
    );
  }
}