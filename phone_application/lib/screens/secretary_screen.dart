import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_fluorography/services/api_reference/request_reference_controller.dart';
import 'package:project_fluorography/styles.dart';
import '../services/builders_screen.dart';
import '../widgets/bottom_navy_bar.dart';

class SecretaryScreen extends ConsumerStatefulWidget {
  const SecretaryScreen({super.key});

  @override
  ConsumerState<SecretaryScreen> createState() => _SecretaryScreen();
}

class _SecretaryScreen extends ConsumerState<SecretaryScreen> {
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
              SecretaryScreenFluorography(),
              SecretaryScreenReference(),
            ],
          ),
          bottomNavigationBar: BottomNavyBar(
            // backgroundColor: Colors.transparent,
            containerHeight: screenHeight * 0.06,
            containerWidth: screenWidth * 0.8,
            itemCornerRadius: 20,
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.2,
              vertical: screenHeight * 0.01,
            ),
            mainAxisAlignment: MainAxisAlignment.center,
            borderRadius: BorderRadius.circular(20),
            showInactiveTitle: true,


            onItemSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
              _pageController.jumpToPage(_currentIndex);
            },

            selectedIndex: _currentIndex,
            items: [
              BottomNavyBarItem(
                title: Text('Флюорография'),
                activeBackgroundColor: AppStyle.blueColorAdditional,
                activeColor: AppStyle.whiteColorMain,
                inactiveColor: AppStyle.blueColorAdditional,
                inactiveTextColor: AppStyle.whiteColorMain,
                activeTextColor: AppStyle.blueColorAdditional,
                textAlign: TextAlign.center,

              ),
              BottomNavyBarItem(
                title: Text('Справки'),
                activeBackgroundColor: AppStyle.blueColorAdditional,
                activeColor: AppStyle.whiteColorMain,
                inactiveColor: AppStyle.blueColorAdditional,
                inactiveTextColor: AppStyle.whiteColorMain,
                activeTextColor: AppStyle.blueColorAdditional,
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecretaryScreenFluorography extends ConsumerStatefulWidget {
  const SecretaryScreenFluorography({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SecretaryScreenFluorography();
}

class _SecretaryScreenFluorography extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Флюорография')));
  }
}

class SecretaryScreenReference extends ConsumerStatefulWidget {
  const SecretaryScreenReference({super.key});

  @override
  _SecretaryScreenReference createState() => _SecretaryScreenReference();
}

class _SecretaryScreenReference
    extends ConsumerState<SecretaryScreenReference> {
  @override
  Widget build(BuildContext context) {
    final controllerProvider = ref.watch(fetchStudentApplicationProvider);
    return Scaffold(
      body: controllerProvider.when(
        data: (application) => ListView.builder(
          itemCount: application.length,
          itemBuilder: (context, index) {
            final item = application[index];
            return ListTile(
              title: Text(item.firstname),
              subtitle: Text(item.phone.toString()),
            );
          },
        ),
        error: (error, stackStrace) =>
            Center(child: Column(children: [Text('Ошибка: $error')])),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
