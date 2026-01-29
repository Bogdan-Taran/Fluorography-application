import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    (context).read<CuratorBloc>().add(CuratorInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BuildersScreen _buildersScreen = BuildersScreen();
    ScreensWidgets _ScreensWidgets = ScreensWidgets();
    return SafeArea(
      child: Scaffold(
        appBar: AppBarFlura(
          bloc: context.read<AuthenticationBloc>(),
          event: SignOutEvent(),
          context: context,
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.13),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: MultiBlocListener(
              listeners: [
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
