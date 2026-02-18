import 'package:colorful_safe_area/colorful_safe_area.dart';
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
  ApiServiceGetCommunityMembers _ApiServiceGetCommunityMembers =
      ApiServiceGetCommunityMembers();
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
  void dispose() {
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

  void updateFilteredCommunity(List<SingleGroupWithStudentsModel> students) {}

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
                      context.read<AdminBloc>().add(OnTapTextFieldEvent());
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
                      final succeessState =
                          state as AdminLoadedGroupsSuccessfulState;
                      return MainContentAccordionBuilder(
                        context,
                        role: 'admin',
                        groups: succeessState.adminGroups,
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
                              'Отсутствуют группы для просмотра',
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
