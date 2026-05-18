import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:core';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_fluorography/bloc/admin/admin_bloc.dart';
import 'package:project_fluorography/widgets/main_content_accordion_builder.dart';
import '../../bloc/internet_connect/interner_connect_cubit.dart';
import '../../models/single_group_with_students_model.dart';
import '../../services/builders_screen.dart';
import '../../services/localDataBase.dart';
import '../../styles.dart';

class AdminScreenFluorography extends StatefulWidget {
  final VoidCallback? onNotificationPressed;
  const AdminScreenFluorography({super.key, this.onNotificationPressed});

  @override
  State<AdminScreenFluorography> createState() => _AdminScreenFluorography();
}

class _AdminScreenFluorography extends State<AdminScreenFluorography> {
  final searchController = TextEditingController();
  List<SingleGroupWithStudentsModel> adminGroups = [];
  CheckerCacheService _CheckerCacheService = CheckerCacheService();

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(AdminFetchEvent());
    _CheckerCacheService.getGroupsCuratorWithCache().then((data) {
      if (mounted) {
        setState(() {
          adminGroups = data;
        });
      }
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
    // Logic is handled in AdminBloc via TextField's onChanged
  }

  @override
  Widget build(BuildContext context) {
    BuildersScreen _buildersScreen = BuildersScreen();

    return Scaffold(
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
              context.read<AdminBloc>().add(OnTapTextFieldEvent());
            },
            onChanged: (query) {
              if (query.length >= 3 || query.isEmpty) {
                context.read<AdminBloc>().add(
                      SearchChangedAdminEvent(
                        query: query.toLowerCase(),
                        groups: adminGroups,
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
              child: Stack(
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
              child: MultiBlocListener(
                listeners: [
                  BlocListener<AdminBloc, AdminState>(
                    listener: (context, state) {
                      if (state is AdminFetchingLoadingState) {
                        // Loading is handled in BlocBuilder
                      }
                    },
                  ),
                  BlocListener<InternetConnectCubit, InternetConnectState>(
                    listener: (context, state) {
                      switch (state.type) {
                        case InternetTypes.connected:
                          Fluttertoast.showToast(
                            msg: 'Есть интернет-соединение',
                            backgroundColor: const Color(0xff78ef81),
                            fontSize: AppStyle.fontSizeMedium_16,
                            gravity: ToastGravity.CENTER,
                            textColor: const Color(0xffffffff),
                          );
                          break;
                        case InternetTypes.offline:
                          Fluttertoast.showToast(
                            msg: 'Отсутствует интернет-соединение',
                            backgroundColor: const Color(0xffed6969),
                            fontSize: AppStyle.fontSizeMedium_16,
                            gravity: ToastGravity.CENTER,
                            textColor: const Color(0xffffffff),
                          );
                          break;
                        case InternetTypes.unknown:
                          Fluttertoast.showToast(
                            msg: 'Об интернет-соединении неизвестно',
                            backgroundColor: const Color(0xff98BFF3),
                            fontSize: AppStyle.fontSizeMedium_16,
                            gravity: ToastGravity.CENTER,
                            textColor: const Color(0xffffffff),
                          );
                          break;
                      }
                    },
                  ),
                ],
                child: BlocBuilder<AdminBloc, AdminState>(
                  builder: (context, state) {
                    if (state is AdminFetchingLoadingState) {
                      return Center(child: _buildersScreen.buildLoading());
                    } else if (state is AdminFetchingErrorState) {
                      return Center(child: Text('Произошла ошибка', style: TextStyle(fontSize: AppStyle.fontSizeMedium_16)));
                    } else if (state is AdminLoadedGroupsSuccessfulState) {
                      return AdminConstructorAccordionBuildWidget(
                        groups: state.adminGroups,
                      );
                    } else if (state is AdminNoDataState) {
                      return Center(
                        child: Text('Ничего не нашлось по вашему запросу', style: TextStyle(fontSize: AppStyle.fontSizeMedium_16)),
                      );
                    } else if (state is AdminFilteredState) {
                      return AdminConstructorAccordionBuildWidget(
                        groups: state.filteredStudents,
                      );
                    } else if (state is AdminUsualState) {
                      return AdminConstructorAccordionBuildWidget(
                        groups: adminGroups,
                      );
                    } else {
                      return Container(
                        padding: REdgeInsets.symmetric(horizontal: 15),
                        width: 1.sw,
                        height: 0.7.sh,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Отсутствуют группы с флюорографией',
                              style: TextStyle(fontSize: AppStyle.fontSizeLarge),
                              textAlign: TextAlign.center,
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
    );
  }
}
