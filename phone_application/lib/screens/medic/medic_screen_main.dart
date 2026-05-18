import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_fluorography/screens/medic/medic_screen_fluorography.dart';
import 'package:project_fluorography/screens/medic/medic_screen_reference.dart';
import 'package:project_fluorography/styles.dart';
import 'package:talker/talker.dart';
import '../../main.dart';
import '../../services/api_reference/request_reference_controller.dart';
import '../../widgets/bottom_navy_bar.dart';
import '../../widgets/show_exit_dialog.dart';
import '../notification_screen.dart';

class MedicScreen extends ConsumerStatefulWidget {
  const MedicScreen({super.key});

  @override
  ConsumerState<MedicScreen> createState() => _MedicScreen();
}

class _MedicScreen extends ConsumerState<MedicScreen> {
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
              fontSize: AppStyle.fontSizeMedium_16,
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
              MedicScreenFluorography(
                onNotificationPressed: () => _pageController.jumpToPage(2),
              ),
              const MedicScreenReference(),
              const NotificationScreen(),
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
              talker.log('MedicScreen: logout pressed');
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
