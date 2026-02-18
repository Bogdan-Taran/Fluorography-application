import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:core';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/bloc/admin/admin_bloc.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import 'package:project_fluorography/widgets/main_content_accordion_builder.dart';
import '../models/single_group_with_students_model.dart';
import '../services/api_service_get_community_members.dart';
import '../services/builders_screen.dart';
import '../services/localDataBase.dart';
import '../services/shared_pref_service.dart';
import '../styles.dart';
import '../widgets/screens_widgets.dart';


class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreen();
}

class _AdminScreen extends State<AdminScreen> {
  late final Future<List<SingleGroupWithStudentsModel>> futureGroupsMethod;
  final searchController = TextEditingController();
  ApiServiceGetCommunityMembers _ApiServiceGetCommunityMembers = ApiServiceGetCommunityMembers();
  List<SingleGroupWithStudentsModel> adminGroups = [];
  CheckerCacheService _CheckerCacheService = CheckerCacheService();

  @override
  void initState() {
    super.initState();
    (context).read<AdminBloc>().add(AdminFetchEvent());
    futureGroupsMethod = _CheckerCacheService.getGroupsAdminWithCache().then((
        data,
        ) {
      adminGroups = data;
      return data;
    });
    searchController.addListener(onSearchChanged);
  }
  @override
  void dispose(){
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void onSearchChanged() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      updateFilteredCommunity(adminGroups);
    } else if (query.length >= 3) {
      final filtered = filterCommunity(adminGroups, query);
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

    return SafeArea(child: Scaffold(
        // appBar: AppBarFlura(
        //   bloc: context.read<AuthenticationBloc>(),
        //   event: SignOutEvent(),
        //   context: context,
        //   preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.13),
        //   searchController: searchController,
        // ),
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
            BlocListener<AdminBloc, AdminState>(
              listener: (context, state) {
                switch (state.runtimeType) {
                  case AdminFetchingLoadingState:
                    print('Загрузка');
                    _buildersScreen.buildLoading();
                    break;
                }
              },
            ),
          ],
          child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case AdminFetchingLoadingState:
                    return Center(child: _buildersScreen.buildLoading());
                  case AdminFetchingErrorState():
                    return Center(child: Text('Ошибка при загрузке'));
                  case AdminLoadedGroupsSuccessfulState:
                    final succeessState = state as AdminLoadedGroupsSuccessfulState;
                    return MainContentAccordionBuilder(
                      context,
                      role: 'admin',
                      groups: succeessState.adminGroups,
                    );
                  default:
                    return Container(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 1,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.8,
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Отсутствуют группы для просмотра',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                }
              }
          ),
        )
    ),)
    ,

    )
    );
  }
}


