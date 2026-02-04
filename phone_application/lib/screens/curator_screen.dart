import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/bloc/curator/curator_bloc.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import '../bloc/search/search_bloc.dart';
import '../services/builders_screen.dart';
import '../widgets/main_content_accordion_builder.dart';
import '../widgets/screens_widgets.dart';

class CuratorScreen extends StatefulWidget {
  const CuratorScreen({super.key});

  @override
  State<CuratorScreen> createState() => _CuratorScreen();
}

class _CuratorScreen extends State<CuratorScreen> {
  final searchController = TextEditingController();
  @override
  void initState() {
    (context).read<CuratorBloc>().add(CuratorInitialEvent());
    super.initState();
  }

  @override
  void dispose(){
    searchController.dispose();
    super.dispose();
}

  @override
  Widget build(BuildContext context) {
    BuildersScreen _buildersScreen = BuildersScreen();
    final appBarHeight = MediaQuery.of(context).size.height * 0.13;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
                          print('Нажата кнопка выхода');
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
                  // TODO
                  /*
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
                    },
                    enableSuggestions: false,
                    autocorrect: false,
                  ),*/
                ],
              ),
            ),
          ),
          toolbarHeight: appBarHeight,
          elevation: 0,
        ),

        body: SingleChildScrollView(
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
                                    WidgetStateProperty.resolveWith<
                                        Color
                                    >((Set<WidgetState> states) {
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
                                    foregroundColor:
                                    WidgetStateProperty.all(
                                      const Color(0xffffffff),
                                    ),
                                    minimumSize: WidgetStateProperty.all(
                                      Size(
                                        MediaQuery.of(context).size.width *
                                            0.1,
                                        35,
                                      ),
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
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
                                    foregroundColor:
                                    WidgetStateProperty.all(
                                      const Color(0xffffffff),
                                    ),
                                    minimumSize: WidgetStateProperty.all(
                                      Size(
                                        MediaQuery.of(context).size.width *
                                            0.1,
                                        35,
                                      ),
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
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
                      // TODO
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SignInScreen(),
                          ),
                        );
                        print('Нажата кнопка выхода');
                        break;
                      case AuthenticationLoadingState:
                        print('Загрузка');
                        _buildersScreen.buildLoading();
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
              child:
              BlocBuilder<CuratorBloc, CuratorState>(
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case CuratorFetchingLoadingState:
                      return Center(child: _buildersScreen.buildLoading());
                    case CuratorFetchingErrorState:
                      return Center(child: Text('Ошибка при загрузке'));
                    case CuratorLoadedGroupsSuccessfulState:
                      final successState =
                          state as CuratorLoadedGroupsSuccessfulState;
                      return MainContentAccordionBuilder(
                        context,
                        role: 'curator',
                        groups: successState.curatorGroups,
                      );/*
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
      ),
    );
  }
}
