import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/bloc/curator/curator_bloc.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import '../bloc/search/search_bloc.dart';
import '../main.dart';
import '../services/api_service_get_community_members.dart';
import '../services/builders_screen.dart';
import '../services/localDataBase.dart';
import '../widgets/main_content_accordion_builder.dart';
import '../widgets/screens_widgets.dart';

class CuratorScreen extends StatefulWidget {
  const CuratorScreen({super.key});

  @override
  State<CuratorScreen> createState() => _CuratorScreen();
}

class _CuratorScreen extends State<CuratorScreen> {
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
    final appBarHeight = MediaQuery.of(context).size.height * 0.13;

    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        resizeToAvoidBottomInset: true,
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
                      context.read<CuratorBloc>().add(OnTapTextFieldEvent());
                    },
                    onChanged: (query) {
                      print('Экран, query: $query');
                      if (query.length >= 3) {
                        context.read<CuratorBloc>().add(
                          SearchChangedCuratorEvent(
                            query: searchController.text.toLowerCase(),
                            groups: curatorGroups
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
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: MultiBlocListener(
                  listeners: [
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
                                            MediaQuery.of(context).size.width * 0.1,
                                            35,
                                          ),
                                        ),
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        print('Экран: Нажата кнопка отмены');
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
                                            MediaQuery.of(context).size.width * 0.1,
                                            35,
                                          ),
                                        ),
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        context.read<AuthenticationBloc>().add(
                                          SignOutAcceptEvent(),
                                        );
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
                    BlocListener<CuratorBloc, CuratorState>(
                      listener: (context, state) {
                        switch (state.runtimeType) {
                          // TODO: убрать все logout
                          // case CuratorFetchingLoadingState:
                          //   print('Загрузка');
                          //   _buildersScreen.buildLoading();
                          //   break;
                        }
                      },
                    ),
                  ],
                  child: BlocBuilder<CuratorBloc, CuratorState>(
                    builder: (context, state) {
                      switch (state.runtimeType) {
                        case CuratorFetchingLoadingState:
                          return Center(child: _buildersScreen.buildLoading());
                        case CuratorFetchingErrorState:
                          return Center(child: Text('Произошла ошибка'));
                        case CuratorLoadedGroupsSuccessfulState:
                          print('Экран: состояние CuratorLoadedGroupsSuccessfulState',);
                          final successState =
                              state as CuratorLoadedGroupsSuccessfulState;
                          return CuratorConstructorAccordionBuildWidget(
                            groups: successState.curatorGroups,
                          );
                          /*
                          return MainContentAccordionBuilder(
                            context,
                            role: 'curator',
                            groups: successState.curatorGroups,
                          );*/
                        /*
                          case SearchUpdatedState
                          BlocBuilder<SearchBloc, SearchState>(
                            builder: (context, state){
                              switch(state.runtimeType){
                                case SearchLoadingState:
                              }
                            }
                          )*/

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
                                  'У вас отстутствуют группы кураторства',
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
          ],
        ),
      ),
    );
  }
}
