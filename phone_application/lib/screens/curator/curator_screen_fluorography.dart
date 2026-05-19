import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/bloc/curator/curator_bloc.dart';
import 'package:project_fluorography/bloc/internet_connect/interner_connect_cubit.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/styles.dart';
import 'package:talker/talker.dart';
import '../../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../../main.dart';
import '../../models/get_reference_model/get_reference_model.dart';
import '../../services/api_reference/request_reference_controller.dart';
import '../../services/api_service_get_community_members.dart';
import '../../services/builders_screen.dart';
import '../../services/localDataBase.dart';
import '../../widgets/expansion_tile.dart' as expansion_tile;
import '../../widgets/main_content_accordion_builder.dart';



class CuratorScreenFluorography extends ConsumerStatefulWidget{
  const CuratorScreenFluorography({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CuratorScreenFluorography();
}
class _CuratorScreenFluorography extends ConsumerState<CuratorScreenFluorography>{
  late final Future<List<SingleGroupWithStudentsModel>> futureGroupsMethod;
  final searchController = TextEditingController();
  ApiServiceGetCommunityMembers _ApiServiceGetCommunityMembers = ApiServiceGetCommunityMembers();
  List<SingleGroupWithStudentsModel> curatorGroups = [];
  CheckerCacheService _CheckerCacheService = CheckerCacheService();
  @override
  void initState() {
    super.initState();
    (context).read<CuratorBloc>().add(CuratorFetchEvent());
    futureGroupsMethod = _CheckerCacheService.getGroupsCuratorWithCache().then((
        data,
        ) {
      curatorGroups = data;
      return data;
    });
    searchController.addListener(onSearchChanged);
  }
  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
  void onSearchChanged() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      updateFilteredCommunity(curatorGroups);
    } else if (query.length >= 3) {
      final filtered = filterCommunity(curatorGroups, query);
      updateFilteredCommunity(filtered);
    }
  }
  List<SingleGroupWithStudentsModel> filterCommunity(
      List<SingleGroupWithStudentsModel> students,
      String query,
      ) {
    return students;
  }
  void updateFilteredCommunity(List<SingleGroupWithStudentsModel> students) {
  }

  @override
  Widget build(BuildContext context) {
    BuildersScreen _buildersScreen = BuildersScreen();

    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: ColorfulSafeArea(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 80.h,
            title: Padding(
              padding: REdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                onTap: () {
                  context.read<CuratorBloc>().add(OnTapTextFieldEvent());
                },
                onChanged: (query) {
                  if (query.length >= 3) {
                    context.read<CuratorBloc>().add(
                          SearchChangedCuratorEvent(
                            query: searchController.text.toLowerCase(),
                            groups: curatorGroups,
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
                  padding: REdgeInsets.symmetric(vertical: 18, horizontal: 8),
                  child: Column(
                    children: [
                      MultiBlocListener(
                        listeners: [
                          BlocListener<CuratorBloc, CuratorState>(
                            listener: (context, state) {
                              switch (state.runtimeType) {
                                case CuratorLogoutSuccessfulState:
                                  break;
                                case CuratorFetchingLoadingState:
                                  _buildersScreen.buildLoading();
                                  break;
                              }
                            },
                          ),
                          BlocListener<AuthenticationBloc, AuthenticationState>(
                            listener: (context, state) {
                              switch (state.runtimeType) {
                                case HasAcceptedLogOutState:
                                  print('Отработало сосотояния выхода');
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Подтверждение выхода'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text('Вы уверены что хотите выйти?'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          // no
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                              WidgetStateProperty.resolveWith<Color>((
                                                  Set<WidgetState> states,
                                                  ) {
                                                if (states.contains(
                                                  WidgetState.disabled,
                                                )) {
                                                  return const Color(0xffD5D6D7);
                                                }
                                                if (states.contains(
                                                  WidgetState.pressed,
                                                )) {
                                                  return const Color(0xFFE4E4E4);
                                                }
                                                if (states.contains(
                                                  WidgetState.hovered,
                                                )) {
                                                  return const Color(0xFFBADEFF);
                                                }
                                                return const Color(0xffffffff);
                                              }),
                                              foregroundColor: WidgetStateProperty.all(
                                                const Color(0xffffffff),
                                              ),
                                              minimumSize: WidgetStateProperty.all(
                                                Size(
                                                  0.1.sw,
                                                  35.h,
                                                ),
                                              ),
                                              shape: WidgetStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.r),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              print('Экран: Нажата кнопка отмены');
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
                                              WidgetStateProperty.resolveWith<Color>((
                                                  Set<WidgetState> states,
                                                  ) {
                                                if (states.contains(
                                                  WidgetState.disabled,
                                                )) {
                                                  return const Color(0xffD5D6D7);
                                                }
                                                if (states.contains(
                                                  WidgetState.pressed,
                                                )) {
                                                  return const Color(0xFF72A7EB);
                                                }
                                                if (states.contains(
                                                  WidgetState.hovered,
                                                )) {
                                                  return const Color(0xFFBADEFF);
                                                }
                                                return const Color(0xff98BFF3);
                                              }),
                                              foregroundColor: WidgetStateProperty.all(
                                                const Color(0xffffffff),
                                              ),
                                              minimumSize: WidgetStateProperty.all(
                                                Size(
                                                  0.1.sw,
                                                  35.h,
                                                ),
                                              ),
                                              shape: WidgetStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.r),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              context.read<AuthenticationBloc>().add(
                                                SignOutAcceptEvent(),
                                              );
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
                                  context.read<CuratorBloc>().add(CuratorLogoutEvent());
                                  break;
                                case AuthenticationLoadingState:
                                  print('Экран: Загрузка AuthenticationLoadingState');
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
                                  context.read<CuratorBloc>().add(
                                    CuratorFetchedNewDateSetEvent(
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
                                      backgroundColor: AppStyle.successGreenColor,
                                      fontSize: AppStyle.fontSizeMedium_16,
                                      gravity: ToastGravity.CENTER,
                                      textColor: AppStyle.whiteColorMain,
                                    );
                                  case InternetTypes.offline:
                                    Fluttertoast.showToast(
                                      msg: 'Отсутствует интернет-соединение',
                                      backgroundColor: AppStyle.errorRedColorMain,
                                      fontSize: AppStyle.fontSizeMedium_16,
                                      gravity: ToastGravity.CENTER,
                                      textColor: AppStyle.whiteColorMain,
                                    );
                                  case InternetTypes.unknown:
                                    Fluttertoast.showToast(
                                      msg: 'Об интернет-соединении неизвестно',
                                      backgroundColor: AppStyle.hoverBlueColorMain,
                                      fontSize: AppStyle.fontSizeMedium_16,
                                      gravity: ToastGravity.CENTER,
                                      textColor: AppStyle.whiteColorMain,
                                    );
                                }
                              })
                        ],
                        child: BlocBuilder<CuratorBloc, CuratorState>(
                          builder: (context, state) {
                            switch (state.runtimeType) {
                              case CuratorFetchingLoadingState:
                                return Center(child: _buildersScreen.buildLoading());
                              case CuratorFetchingErrorState:
                                final errorState = state as CuratorFetchingErrorState;
                                return Center(child: Text('${errorState.message}'));
                              case CuratorLoadedGroupsSuccessfulState:
                                print('Экран: состояние CuratorLoadedGroupsSuccessfulState',);
                                final successState =
                                state as CuratorLoadedGroupsSuccessfulState;
                                if(successState.curatorGroups.contains('message')){
                                  return Text('Нет групп кураторства');
                                }
                                else {return CuratorConstructorAccordionBuildWidget(
                                  groups: successState.curatorGroups,
                                );
                                }
                              case CuratorSearchState:
                                print('Экран: состояние CuratorSearchState');
                                return SizedBox();
                              case CuratorNoDataState:
                                print('Экран: состояние CuratorNoDataState');
                                return Center(
                                  child: Text(
                                    'Ничего не нашлось по вашему заросу',
                                  ),
                                );
                              case CuratorFilteredState:
                                final successfulState =
                                state as CuratorFilteredState;
                                print('Экран: CuratorFilteredState');
                                print(successfulState.filteredStudents);
                                return CuratorConstructorAccordionBuildWidget(groups: successfulState.filteredStudents);
                              case CuratorUsualState:
                                print('Экран: состояние CuratorUsualState');
                                return CuratorConstructorAccordionBuildWidget(groups: curatorGroups);


                              default:
                                return Container(
                                  padding: REdgeInsets.symmetric(horizontal: 15),
                                  width: 1.sw,
                                  height: 0.8.sh,
                                  decoration: const BoxDecoration(color: Colors.transparent),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'У вас отстутствуют группы кураторства',
                                        style: TextStyle(fontSize: AppStyle.fontSizeExtraLarge),
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