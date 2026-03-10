import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ColorfulSafeArea(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Color(0xffffffff),
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
            backgroundColor: Colors.transparent,
            showElevation: false,
            shadowColor: Colors.transparent,
            mainAxisAlignment: MainAxisAlignment.center,
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
                activeColor: AppStyle.blueColorAdditional,
                inactiveColor: AppStyle.blueColorAdditional,
                  textAlign: TextAlign.center
              ),
              BottomNavyBarItem(
                title: Text('Справки'),
                activeColor: AppStyle.blueColorAdditional,
                inactiveColor: AppStyle.blueColorAdditional,
                textAlign: TextAlign.center
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

class _SecretaryScreenReference extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Справки')));
  }
}
