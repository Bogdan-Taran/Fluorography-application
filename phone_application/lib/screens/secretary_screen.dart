import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_fluorography/services/api_reference/request_reference_controller.dart';
import 'package:project_fluorography/styles.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../main.dart';
import '../models/get_reference_model/get_reference_model.dart';
import '../services/builders_screen.dart';
import '../widgets/bottom_navy_bar.dart';
import '../widgets/expansion_tile.dart' as expansion_tile;
import 'notification_screen.dart';

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
    final buttonSize = screenWidth * 0.047;
    final iconSize = screenWidth * 0.05;

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
              NotificationScreen(),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(
                        SignOutEvent(),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthChecker(),
                        ),
                      );
                    },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(buttonSize),
                    backgroundColor: AppStyle.blueColorAdditional,
                  ),
                  child: SvgPicture.asset(
                    'assets/icon/door_icon.svg',
                    colorFilter: const ColorFilter.mode(
                      AppStyle.whiteColorMain,
                      BlendMode.srcIn,
                    ),
                    width: iconSize,
                  ),
                ),
                BottomNavyBar(
                  // backgroundColor: Colors.transparent,
                  containerHeight: screenHeight * 0.06,
                  containerWidth: screenWidth * 0.6,
                  itemCornerRadius: 20,
                  margin: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenHeight * 0.005
                  ),
                  mainAxisAlignment: MainAxisAlignment.center,
                  borderRadius: BorderRadius.circular(20),
                  showInactiveTitle: true,
                  itemBorderColor: AppStyle.whiteColorMain,
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
                ElevatedButton(
                  onPressed: () {
                    _pageController.jumpToPage(2);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(buttonSize),
                    backgroundColor: AppStyle.blueColorAdditional,
                  ),
                  child: SvgPicture.asset(
                  'assets/icon/notification_white_icon.svg',
                  colorFilter: const ColorFilter.mode(
                    AppStyle.whiteColorMain,
                    BlendMode.srcIn,
                  ),
                  width: iconSize,
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Флюорография секретерь
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





// Справки секретерь
class SecretaryScreenReference extends ConsumerStatefulWidget {
  const SecretaryScreenReference({super.key});

  @override
  _SecretaryScreenReference createState() => _SecretaryScreenReference();
}

class _SecretaryScreenReference
    extends ConsumerState<SecretaryScreenReference> {
  @override
  Widget build(BuildContext context) {
    final groupedData = ref.watch(groupedApplicationsByGroup);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppStyle.whiteColorMain,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: groupedData.when(
          data: (data) {
            final groups = data.keys.toList();
            if(groups.isEmpty) return const Center(child: Text('Нет справок'));
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index){
                final groupName = groups[index];
                final students = data[groupName]!;
                return expansion_tile.ExpansionTile(
                  title: Text('Группа $groupName'),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: AppStyle.collapsedBlueColor,
                      width: 1
                    )
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                          color: AppStyle.collapsedBlueColor,
                          width: 1
                      )
                  ),
                  children: students.map((student) {
                    return ListTile(
                      contentPadding: EdgeInsetsGeometry.symmetric(vertical: screenHeight * 0.05),
                      title: Text('Студент ${student.firstname} ${student.lastname}'),
                      subtitle: Text('Телефон: ${student.phone}'),
                      trailing: Text('Статус: ${student.statusId.toString()}'),
                      onTap: (){},
                    );

                  }).toList(),
                );
              },
            );
          },
          error: (error, stackTrace) => Center(child: Text('Ошибка: $error')),
          loading: () => const Center(child: CircularProgressIndicator())
        ),
      )
    );
  }
}
