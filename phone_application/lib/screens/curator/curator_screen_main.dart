import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/bloc/curator/curator_bloc.dart';
import 'package:project_fluorography/bloc/internet_connect/interner_connect_cubit.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/screens/curator/curator_screen_fluorography.dart';
import 'package:project_fluorography/screens/curator/curator_screen_reference.dart';
import 'package:project_fluorography/styles.dart';
import 'package:talker/talker.dart';
import '../../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../../main.dart';
import '../../models/get_reference_model/get_reference_model.dart';
import '../../services/api_reference/request_reference_controller.dart';
import '../../services/api_service_get_community_members.dart';
import '../../services/builders_screen.dart';
import '../../services/localDataBase.dart';
import '../../widgets/bottom_navy_bar.dart';
import '../../widgets/expansion_tile.dart' as expansion_tile;
import '../../widgets/main_content_accordion_builder.dart';
import '../../widgets/show_exit_dialog.dart';
import '../notification_screen.dart';

class CuratorScreen extends ConsumerStatefulWidget {
  const CuratorScreen({super.key});

  @override
  ConsumerState<CuratorScreen> createState() => _CuratorScreen();
}

class _CuratorScreen extends ConsumerState<CuratorScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final talker = Talker();
    ref.listen<AsyncValue<String?>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
          data: (message){
            if (message != null) {
              // Закрываем диалог перед переходом
              Navigator.of(context, rootNavigator: true).pop(); 
              
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthChecker(),
                  )
              );
            }
          },
          error: (error, stack) {
            Fluttertoast.showToast(
              msg: 'Ошибка: $error',
              backgroundColor: const Color(0xffed6969),
              fontSize: 16,
              gravity: ToastGravity.CENTER,
              textColor: const Color(0xffffffff),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          )
      );
    });

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ColorfulSafeArea(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: AppStyle.whiteColorMain,
          resizeToAvoidBottomInset: true,
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              CuratorScreenFluorography(),
              CuratorScreenReference(),
              NotificationScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavBarFLura(
            currentIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
              _pageController.jumpToPage(_currentIndex);
            },
            onLogoutPressed: ()  {
              talker.log('CuratorScreen: logout pressed');
              showDialog(
                  context: context,
                  builder: (context) => ShowExitDialog(
                    onNoPressed: Navigator.of(context).pop,
                    onYesPressed: (){
                      ref.read(authControllerProvider.notifier).logout();
                    },
                  )
              );
            },
            onNotificationPressed: () {
              _pageController.jumpToPage(2);
            },

          ),
        ),
      ),
    );
  }
}








