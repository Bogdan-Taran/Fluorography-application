import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/bloc/medic/medic_bloc.dart';
import 'package:project_fluorography/bloc/search/search_bloc.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../main.dart';
import '../models/staff_and_students_model.dart';
import '../services/builders_screen.dart';
import '../services/localDataBase.dart';
import '../widgets/main_content_accordion_builder.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';

import '../widgets/main_content_accordion_builder_light.dart';

class MedicScreen extends StatefulWidget {
  const MedicScreen({super.key});

  @override
  State<MedicScreen> createState() => _MedicScreen();
}

class _MedicScreen extends State<MedicScreen> {
  late final Future<List<StaffAndStudentsModel>> futureCommunity;
  TextEditingController searchController = TextEditingController();
  CheckerCacheService _CheckerCacheService = CheckerCacheService();

  List<StaffAndStudentsModel> allCommunity = [];
  List<StaffAndStudentsModel> filteredCommunity = [];

  @override
  void initState() {
    super.initState();
    // (context).read<MedicBloc>().add(MedicInitialEvent());
    (context).read<MedicBloc>().add(MedicFetchEvent());
    futureCommunity = _CheckerCacheService.getGroupsMedicWithCache().then((
      data,
    ) {
      allCommunity = data;
      filteredCommunity = data;
      return data;
    });

    searchController.addListener(onSearchChanged);
  }

  void onSearchChanged() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      updateFilteredCommunity(allCommunity);
    } else if (query.length >= 3) {
      final filtered = filterCommunity(allCommunity, query);
      updateFilteredCommunity(filtered);
    }
  }

  List<StaffAndStudentsModel> filterCommunity(
    List<StaffAndStudentsModel> community,
    String query,
  ) {
    return community;
  }

  void updateFilteredCommunity(List<StaffAndStudentsModel> community) {
    // if(mounted){
    //       setState(() {
    //         _filteredGroups = groups;
    //       });
    //     }
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  FutureOr _printLatestValue() async {
    if (searchController.text.length >= 3) {
      print('Экран:  =Введенный текст: ${searchController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    BuildersScreen _buildersScreen = BuildersScreen();
    final appBarHeight = MediaQuery.of(context).size.height * 0.13;
    final blueColor = Color(0xff98BFF3);


    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xffffffff),
        // AppBar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: Container(
            height: appBarHeight,
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        splashRadius: 24,
                        padding: EdgeInsets.zero,
                        icon: SvgPicture.asset(
                          'assets/images/notification_icon.svg',
                          color: const Color(0xff98BFF3),
                          width: 35,
                          height: 35,
                        ),
                      ),

                      // Sign Out Button
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>((
                                Set<WidgetState> states,
                              ) {
                                if (states.contains(WidgetState.disabled)) {
                                  return const Color(0xffD5D6D7);
                                }
                                if (states.contains(WidgetState.pressed)) {
                                  return const Color(0xFF72A7EB);
                                }
                                if (states.contains(WidgetState.hovered)) {
                                  return const Color(0xFFBADEFF);
                                }
                                return const Color(0xff98BFF3);
                              }),
                          foregroundColor: WidgetStateProperty.all(
                            const Color(0xffffffff),
                          ),
                          minimumSize: WidgetStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.1, 35),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          context.read<AuthenticationBloc>().add(
                            SignOutEvent(),
                          );
                          print('Экран: Нажата кнопка выхода');
                        },
                        child: const Text(
                          'Выход',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Geologica',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onTap: () {
                      context.read<MedicBloc>().add(OnTapTextFieldEvent());
                    },
                    onChanged: (query) {
                      print('Экран, query: $query');
                      if (query.length >= 3) {
                        context.read<MedicBloc>().add(
                          SearchChangedMedicEvent(
                            query: searchController.text.toLowerCase(),
                            entireGroups: allCommunity,
                          ),
                        );
                      }
                    },
                    controller: searchController,
                    cursorColor: Color(0xff72A7EB),
                    cursorHeight: 25,
                    cursorWidth: 1.5,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: SvgPicture.asset(
                          'assets/images/serch_icon.svg',
                          width: 20,
                          height: 20,
                          color: const Color(0xff98BFF3),
                        ),
                      ),
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: Color(0xff98BFF3),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: Color(0xff72A7EB),
                          width: 2,
                        ),
                      ),
                      hintText: 'Поиск',
                      hintStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.016,
                        color: Color(0xff98BFF3),
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    ),
                    keyboardType: TextInputType.text,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      // context.read<MedicBloc>().add(
                      //     OnTapOutsideTextFieldMedicEvent()
                      // );
                    },
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                ],
              ),
            ),
          ),
          toolbarHeight: appBarHeight,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: IgnorePointer(
                child: // Декорации
                Stack(
                  children: [
                    Align(
                      alignment: Alignment(1, -1),
                      child: SvgPicture.asset(
                        'assets/images/vectorRight.svg',
                        semanticsLabel: 'Top SVG Image',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Align(
                      alignment: Alignment(1, 0.5),
                      child: SvgPicture.asset(
                        'assets/images/vectorLine.svg',
                        semanticsLabel: 'Top SVG Image',
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width * 1,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      // alignment: Alignment(1, 0.7),
                      child: SvgPicture.asset(
                        'assets/images/vectorBottom.svg',
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width * 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Column(
                  children: [
                    MultiBlocListener(
                      listeners: [
                        BlocListener<MedicBloc, MedicState>(
                          listener: (context, state) {
                            switch (state.runtimeType) {
                              // case MedicLogoutSuccessfulState:
                              //   print('Отработало сосотояния выхода');
                              //   Navigator.of(context).pushReplacement(
                              //     MaterialPageRoute(
                              //       builder: (BuildContext context) =>
                              //           SignInScreen(),
                              //     ),
                              //   );
                              //   break;
                              // case MedicLogoutErrorState:
                              //   print('Ошибка при попытке выхода');
                              //   break;
                              case MedicLogoutSuccessfulState:
                                print('Отработало сосотояния выхода');
                                break;
                              case MedicFetchingLoadingState:
                                _buildersScreen.buildLoading();
                                print(
                                  'Экран: Загрузка MedicFetchingLoadingState',
                                );
                                break;
                            }
                          },
                        ),
                        BlocListener<AuthenticationBloc, AuthenticationState>(
                          listener: (context, state) {
                            switch (state.runtimeType) {
                              case HasAcceptedLogOutState:
                                print(
                                  'Экран: появилось контекстное меню сосотояние подтверждения выхода',
                                );
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Подтверждение выхода'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                              'Вы уверены что хотите выйти?',
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        // no
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.resolveWith<
                                                  Color
                                                >((Set<WidgetState> states) {
                                                  if (states.contains(
                                                    WidgetState.disabled,
                                                  )) {
                                                    return const Color(
                                                      0xffD5D6D7,
                                                    );
                                                  }
                                                  if (states.contains(
                                                    WidgetState.pressed,
                                                  )) {
                                                    return const Color(
                                                      0xFFE4E4E4,
                                                    );
                                                  }
                                                  if (states.contains(
                                                    WidgetState.hovered,
                                                  )) {
                                                    return const Color(
                                                      0xFFBADEFF,
                                                    );
                                                  }
                                                  return const Color(
                                                    0xffffffff,
                                                  );
                                                }),
                                            foregroundColor:
                                                WidgetStateProperty.all(
                                                  const Color(0xffffffff),
                                                ),
                                            minimumSize:
                                                WidgetStateProperty.all(
                                                  Size(
                                                    MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.1,
                                                    35,
                                                  ),
                                                ),
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            print(
                                              'Экран: Нажата кнопка отмены',
                                            );
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Отмена',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff98BFF3),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Geologica',
                                            ),
                                          ),
                                        ),
                                        //yes
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.resolveWith<
                                                  Color
                                                >((Set<WidgetState> states) {
                                                  if (states.contains(
                                                    WidgetState.disabled,
                                                  )) {
                                                    return const Color(
                                                      0xffD5D6D7,
                                                    );
                                                  }
                                                  if (states.contains(
                                                    WidgetState.pressed,
                                                  )) {
                                                    return const Color(
                                                      0xFF72A7EB,
                                                    );
                                                  }
                                                  if (states.contains(
                                                    WidgetState.hovered,
                                                  )) {
                                                    return const Color(
                                                      0xFFBADEFF,
                                                    );
                                                  }
                                                  return const Color(
                                                    0xff98BFF3,
                                                  );
                                                }),
                                            foregroundColor:
                                                WidgetStateProperty.all(
                                                  const Color(0xffffffff),
                                                ),
                                            minimumSize:
                                                WidgetStateProperty.all(
                                                  Size(
                                                    MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.1,
                                                    35,
                                                  ),
                                                ),
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            context
                                                .read<AuthenticationBloc>()
                                                .add(SignOutAcceptEvent());
                                          },
                                          child: const Text(
                                            'Да',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xffffffff),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Geologica',
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                break;

                              case AuthenticationLogOutState:
                                //   TODO: попробовать добавить mounted
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AuthChecker(),
                                  ),
                                );
                                context.read<MedicBloc>().add(
                                  MedicLogoutEvent(),
                                );
                                print(
                                  'Экран: Нажата кнопка подтверждения выхода',
                                );
                                break;
                              case AuthenticationLoadingState:
                                print(
                                  'Экран: Загрузка AuthenticationLoadingState',
                                );
                                _buildersScreen.buildLoading();
                                break;
                              case AuthenticationLogOutErrorState:
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      title: Text("Ошибка"),
                                      content: Text(
                                        'Произошла ошибка при попытке выйти',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(dialogContext).pop(),
                                          child: Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
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
                                print('Экран: состояние SuccessfullyPatchedSetDatesState');
                                // здесь подставляются tempDates из главного State
                                final datesState =
                                    state as SuccessfullyPatchedSetDatesState;
                                context.read<MedicBloc>().add(
                                  MedicFetchedNewDateSetEvent(
                                    newDateSet: datesState.newDateSet,
                                  ),
                                );
                            }
                          },
                        ),
                      ],

                      // child: Text('Лягушка')
                      child: BlocBuilder<MedicBloc, MedicState>(
                        builder: (context, medicState) {
                          switch (medicState.runtimeType) {
                            case MedicFetchingLoadingState:
                              print('Экран: состояние MedicFetchingLoadingState');
                              return Center(child: _buildersScreen.buildLoading());
                            case MedicFetchingErrorState:
                              print('Экран: состояние MedicFetchingErrorState');
                              return Center(child: Text('Произошла ошибка'));
                            case MedicLoadedCommunitySuccessfulState:
                              print('Экран: состояние MedicLoadedCommunitySuccessfulState',);
                              final successfulState =
                                  medicState
                                      as MedicLoadedCommunitySuccessfulState;

                              return MedicConstructorAccordionBuildWidget(
                                medicEntireCommunity:
                                    successfulState.medicEntireCommunity,
                              );
                            /*
                              return MedicConstructorAccordionBuildWidget(
                                medicEntireCommunity:
                                    successfulState.medicEntireCommunity,
                              );*/
                            case MedicSearchState:
                              print('Экран: состояние MedicSearchState');
                              return SizedBox(
                                height: MediaQuery.of(context).size.height * 1,
                                width: MediaQuery.of(context).size.width * 1,
                              );
                            case MedicNoDataState:
                              print('Экран: состояние MedicNoDataState');
                              return Center(
                                child: Text(
                                  'Экран: Ничего не нашлось по вашему заросу',
                                ),
                              );
                            case MedicFilteredState:

                              final successfulState =
                                  medicState as MedicFilteredState;
                              print('Экран: MedicFilteredState');
                              print(successfulState.medicFilteredCommunity);
                              return MedicConstructorAccordionBuildWidget(
                                medicEntireCommunity:
                                    successfulState.medicFilteredCommunity,
                              );
                            case MedicUsualState:
                              print('Экран: состояние MedicUsualState');
                              return MedicConstructorAccordionBuildWidget(
                                medicEntireCommunity: allCommunity,
                              );
                            default:
                              print('Экран: состояние default');
                              return Container(
                                padding: EdgeInsetsGeometry.symmetric(
                                  horizontal: 15,
                                ),
                                width: MediaQuery.of(context).size.width * 1,
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
