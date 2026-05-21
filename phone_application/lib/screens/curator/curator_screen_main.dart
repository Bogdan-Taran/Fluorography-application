import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_fluorography/screens/curator/curator_screen_fluorography.dart';
import 'package:project_fluorography/screens/curator/curator_screen_reference.dart';
import 'package:project_fluorography/styles.dart';
import 'package:talker/talker.dart';
import '../../main.dart';
import '../../services/api_reference/request_reference_controller.dart';
import '../../widgets/bottom_navy_bar.dart';
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
              if (Navigator.of(context, rootNavigator: true).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthChecker()),
                (route) => false,
              );
            }
          },
          error: (error, stack) {
            Fluttertoast.showToast(
              msg: 'Ошибка: $error',
              backgroundColor: AppStyle.errorRedColorMain,
              fontSize: AppStyle.fontSizeMedium_16,
              gravity: ToastGravity.CENTER,
              textColor: AppStyle.whiteColorMain,
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          )
      );
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
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








