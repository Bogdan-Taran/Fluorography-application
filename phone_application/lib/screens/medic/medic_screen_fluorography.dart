import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:project_fluorography/bloc/medic/medic_bloc.dart';
import 'package:project_fluorography/bloc/search/search_bloc.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/internet_connect/interner_connect_cubit.dart';
import '../../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../../main.dart';
import '../../models/staff_and_students_model.dart';
import '../../services/builders_screen.dart';
import '../../services/localDataBase.dart';
import '../../widgets/main_content_accordion_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_fluorography/styles.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';


class MedicScreenFluorography extends StatefulWidget {
  final VoidCallback? onNotificationPressed;
  const MedicScreenFluorography({super.key, this.onNotificationPressed});

  @override
  State<MedicScreenFluorography> createState() => _MedicScreenFluorography();
}

class _MedicScreenFluorography extends State<MedicScreenFluorography> {
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
    final appBarHeight = 80.h;

    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: ColorfulSafeArea(
        color: Colors.white,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: appBarHeight,
            title: Padding(
              padding: REdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                onTap: () {
                  context.read<MedicBloc>().add(OnTapTextFieldEvent());
                },
                onChanged: (query) {
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
                cursorColor: const Color(0xff72A7EB),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  prefixIcon: Padding(
                    padding: REdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/images/serch_icon.svg',
                      width: 20.w,
                      height: 20.h,
                      color: const Color(0xff98BFF3),
                    ),
                  ),
                  hintText: 'Поиск',
                  hintStyle: TextStyle(
                    fontSize: AppStyle.fontSizeMedium_16,
                    color: const Color(0xff26292B),
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
          ),
          body: Stack(
            children: [
              SizedBox(
                width: 1.sw,
                height: 1.sh,
                child: IgnorePointer(
                  child: // Декорации
                  Stack(
                    children: [
                      Align(
                        alignment: const Alignment(1, -1),
                        child: SvgPicture.asset(
                          'assets/images/vectorRight.svg',
                          semanticsLabel: 'Top SVG Image',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Align(
                        alignment: const Alignment(1, 0.5),
                        child: SvgPicture.asset(
                          'assets/images/vectorLine.svg',
                          semanticsLabel: 'Top SVG Image',
                          fit: BoxFit.fill,
                          width: 1.sw,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        // alignment: Alignment(1, 0.7),
                        child: SvgPicture.asset(
                          'assets/images/vectorBottom.svg',
                          fit: BoxFit.fitWidth,
                          width: 1.sw,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Column(
                    children: [
                      MultiBlocListener(
                        listeners: [
                          BlocListener<MedicBloc, MedicState>(
                            listener: (context, state) {
                              switch (state.runtimeType) {
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
                                        title: Text('Подтверждение выхода', style: TextStyle(fontSize: AppStyle.fontSizeLarge)),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                'Вы уверены что хотите выйти?',
                                                style: TextStyle(fontSize: AppStyle.fontSizeMedium_16),
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
                                                      0.1.sw,
                                                      35.h,
                                                    ),
                                                  ),
                                              shape: WidgetStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10.r),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              print(
                                                'Экран: Нажата кнопка отмены',
                                              );
                                              context.read<AuthenticationBloc>().add(SignOutCancelEvent());
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Отмена',
                                              style: TextStyle(
                                                fontSize: AppStyle.fontSizeMedium_16,
                                                color: const Color(0xff98BFF3),
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
                                                      0.1.sw,
                                                      35.h,
                                                    ),
                                                  ),
                                              shape: WidgetStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10.r),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              context
                                                  .read<AuthenticationBloc>()
                                                  .add(SignOutAcceptEvent());
                                            },
                                            child: Text(
                                              'Да',
                                              style: TextStyle(
                                                fontSize: AppStyle.fontSizeMedium_16,
                                                color: const Color(0xffffffff),
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
                                  print(
                                    'Экран: состояние SuccessfullyPatchedSetDatesState',
                                  );
                                  final datesState =
                                      state as SuccessfullyPatchedSetDatesState;
                                  showPopMessage(
                                    context,
                                    'Успешнаое сохранение',
                                    true,
                                  );
                                  context.read<MedicBloc>().add(
                                    MedicFetchedNewDateSetEvent(
                                      newDateSet: datesState.newDateSet,
                                    ),
                                  );
                                  break;
                                case FailToPatchDatesState:
                                  showPopMessage(
                                    context,
                                    'Ошибка при сохранении',
                                    false,
                                  );
                              }
                            },
                          ),
                          BlocListener<InternetConnectCubit, InternetConnectState>(
                              listener: (context, state) {
                                switch(state.type){
                                  case InternetTypes.connected:
                                    Fluttertoast.showToast(
                                      msg: 'Есть интернет-соединение',
                                      backgroundColor: const Color(0xff78ef81),
                                      fontSize: AppStyle.fontSizeMedium_16,
                                      gravity: ToastGravity.CENTER,
                                      textColor: const Color(0xffffffff),
                                    );
                                  case InternetTypes.offline:
                                    Fluttertoast.showToast(
                                      msg: 'Отсутствует интернет-соединение',
                                      backgroundColor: const Color(0xffed6969),
                                      fontSize: AppStyle.fontSizeMedium_16,
                                      gravity: ToastGravity.CENTER,
                                      textColor: const Color(0xffffffff),
                                    );
                                  case InternetTypes.unknown:
                                    Fluttertoast.showToast(
                                      msg: 'Об интернет-соединении неизвестно',
                                      backgroundColor: const Color(0xff98BFF3),
                                      fontSize: AppStyle.fontSizeMedium_16,
                                      gravity: ToastGravity.CENTER,
                                      textColor: const Color(0xffffffff),
                                    );
                                }
                              })
                        ],

                        child: BlocBuilder<MedicBloc, MedicState>(
                          builder: (context, medicState) {
                            switch (medicState.runtimeType) {
                              case MedicFetchingLoadingState:
                                print(
                                  'Экран: состояние MedicFetchingLoadingState',
                                );
                                return Center(
                                  child: _buildersScreen.buildLoading(),
                                );
                              case MedicFetchingErrorState:
                                print('Экран: состояние MedicFetchingErrorState');
                                return Center(child: Text('Произошла ошибка'));
                              case MedicLoadedCommunitySuccessfulState:
                                searchController.clear();
                                print(
                                  'Экран: состояние MedicLoadedCommunitySuccessfulState',
                                );
                                final successfulState =
                                    medicState
                                        as MedicLoadedCommunitySuccessfulState;
                                return MedicConstructorAccordionBuildWidget(
                                  medicEntireCommunity:
                                      successfulState.medicEntireCommunity,
                                );

                              case MedicSearchState:
                                print('Экран: состояние MedicSearchState');
                                return SizedBox();
                              case MedicNoDataState:
                                print('Экран: состояние MedicNoDataState');
                                return Center(
                                  child: Text(
                                    'Ничего не нашлось по вашему заросу',
                                    style: TextStyle(fontSize: AppStyle.fontSizeLarge),
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
                                  padding: REdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  width: 1.sw,
                                  height: 0.8.sh,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Отсутствуют сотрудники или студенты',
                                        style: TextStyle(fontSize: AppStyle.fontSizeLarge),
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
      ),
    );
  }
}
