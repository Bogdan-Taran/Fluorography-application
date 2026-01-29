import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_fluorography/bloc/medic/medic_bloc.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../services/builders_screen.dart';
import '../widgets/main_content_accordion_builder.dart';
import '../widgets/screens_widgets.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';

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


    return ColorfulSafeArea(
      color: Colors.white,
        child: Scaffold(
            appBar: AppBarFlura(
              bloc: context.read<AuthenticationBloc>(),
              event: SignOutEvent(),
              context: context,
              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.13),
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
                                  builder: (BuildContext context) => SignInScreen(),
                                ),
                              );
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
                        },
                      ),
                      BlocListener<AuthenticationBloc, AuthenticationState>(
                        listener: (context, state) {
                          switch (state.runtimeType) {
                            case AuthenticationLogOutState:
                              print('Отработало сосотояния выхода');
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SignInScreen(),
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
                      BlocListener<
                        WorkingWithFluorographyBloc,
                        WorkingWithFluorographyState
                      >(
                        listener: (context, state) {
                          switch (state.runtimeType) {
                            case SuccessfullyPatchedSetDatesState:
                              // здесь подставляются tempDates из главного State
                              context.read<MedicBloc>().add(
                                MedicFetchedNewDateSetEvent(
                                  newDateSet: state.tempDates,
                                ),
                              );
                          }
                        },
                      ),
                    ],
                    child: BlocBuilder<MedicBloc, MedicState>(
                      builder: (context, medicState) {
                        switch (medicState.runtimeType) {
                          case MedicFetchingLoadingState:
                            return Center(child: _buildersScreen.buildLoading());
                          case MedicFetchingErrorState:
                            return Center(child: Text('Произошла ошибка'));

                          case MedicLoadedCommunitySuccessfulState:
                            final successfulState =
                                medicState as MedicLoadedCommunitySuccessfulState;
                            print('Печатаю лист');
                            print(successfulState.medicEntireCommunity);
                            return MainContentAccordionBuilder(
                              context,
                              role: 'medic',
                              medicEntireCommunity:
                                  successfulState.medicEntireCommunity,
                            );
                          default:
                            return Container(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.height * 0.8,
                              decoration: BoxDecoration(color: Colors.transparent),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Отсутствуют сотрудники или студенты',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            );
                        }
                      },
                    ),
                  ),
                ),
              ),
            )
    );
  }
}
