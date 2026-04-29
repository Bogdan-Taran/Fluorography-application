import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/screens/admin/admin_screen_fluorography.dart';
import 'package:project_fluorography/screens/admin/admin_screen_reference.dart';
import 'package:project_fluorography/styles.dart';
import '../../widgets/bottom_navy_bar.dart';
import '../../widgets/show_exit_dialog.dart';
import '../notification_screen.dart';
import '../../main.dart';

class AdminMainScreen extends ConsumerStatefulWidget {
  const AdminMainScreen({super.key});

  @override
  ConsumerState<AdminMainScreen> createState() => _AdminMainScreen();
}

class _AdminMainScreen extends ConsumerState<AdminMainScreen> {
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
              AdminScreenFluorography(
                onNotificationPressed: () => _pageController.jumpToPage(2),
              ),
              const AdminScreenReference(),
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
              showDialog(
                  context: context,
                  builder: (context) => ShowExitDialog(
                    onNoPressed: Navigator.of(context).pop,
                    onYesPressed: (){
                      Navigator.of(context).pop();
                      context.read<AuthenticationBloc>().add(SignOutAcceptEvent());
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
