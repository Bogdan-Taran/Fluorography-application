import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/services/api_reference/request_reference_controller.dart';
import 'package:project_fluorography/styles.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../main.dart';
import '../models/get_reference_model/get_reference_model.dart';
import '../services/builders_screen.dart';
import '../services/converters_service.dart';
import '../widgets/bottom_navy_bar.dart';
import '../widgets/expansion_tile.dart' as expansion_tile;
import 'notification_screen.dart';
import 'package:project_fluorography/models/get_reference_model/get_reference_model.dart';

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
    ConverterServices _ConverterServices = ConverterServices();

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
  final Map<int, bool> _isExpandedTile = {};
  @override
  Widget build(BuildContext context) {
    final groupedData = ref.watch(groupedApplicationsByGroup);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final BuildersScreen _BuildersScreen = BuildersScreen();
    ref.listen<AsyncValue<void>>(updateReferenceStatusControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Ошибка'),
              content: Text(error.toString()),
            ),
          );
        },
        data: (_){
          showDialog(
              context: context,
              builder: (context)=> AlertDialog(
                title: Text('Успешно'),
                content: Text('Статус успешно изменен'),
              )
          );
        }
      );
    });

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

                final bool groupHasActiveReferences = students.any((s) => s.status_id == 1);
                return expansion_tile.ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Группа $groupName',
                          style: TextStyle(
                            color: AppStyle.blueColorTextTitle,
                            fontSize: AppStyle.fontSizeMedium,
                            fontWeight: FontWeight.w500,
                          ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: groupHasActiveReferences
                        ? BoxDecoration(
                          color: AppStyle.redColorTag,
                          borderRadius: BorderRadius.circular(10),
                        )
                        : BoxDecoration(
                          color: AppStyle.blueColorAdditional,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${students.length}',
                              style: TextStyle(
                                color: AppStyle.whiteColorMain,
                                fontSize: AppStyle.fontSizeSmall,
                              )
                            ),
                            SvgPicture.asset(
                              'assets/images/people_icon.svg',
                              color: AppStyle.whiteColorMain,
                            )
                          ]
                        ),
                      )
                    ],
                  ),
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
                  trailing: SvgPicture.asset(
                    _isExpandedTile[index] == true
                        ? 'assets/images/icon_expand_down2.svg'
                        : 'assets/images/icon_expand_right.svg',
                  ),
                  onExpansionChanged: (bool expanded){
                    setState(() {
                      _isExpandedTile[index] = expanded;
                    });
                  },
                  children: students.map((student) {
                    return ListTile(
                      contentPadding: EdgeInsetsGeometry.symmetric(vertical: screenHeight * 0.0015),
                      title: Text('Студент ${student.firstname} ${student.lastname}'),
                      subtitle: Text('Телефон: ${student.phone}'),
                      trailing:  (student.status_id == 1)
                          ? SvgPicture.asset(
                        'assets/icon/reference_warn.svg',
                        width: screenWidth * 0.05,
                      )
                          : SizedBox(),
                      onTap: () async{
                        final studentData = ref.read(fetchStudentApplicationProvider)
                        showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: Container(
                                  width: screenWidth * 0.02,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppStyle.collapsedBlueColor,
                                        width: 1
                                      )
                                    )
                                  ),
                                  child: Text(
                                      'История справок',
                                      style: TextStyle(
                                        fontSize: AppStyle.fontSizeExtraLarge,
                                        fontWeight: FontWeight.w500,
                                        color: AppStyle.blackColorMain,
                                      ),
                                  ),
                                ),
                                content: Column(
                                  children: [
                                    ListTile(
                                      title: Text('${student.lastname} ${student.firstname} ${student.patronymic}'),
                                      subtitle: Text('группа ${student.group}, ${student.phone}'),
                                    )
                                  ],
                                ),
                              );
                            }
                        );






                        /*await ref.read(updateReferenceStatusControllerProvider.notifier).updateStatus(
                            applicationId: student.id,
                            statusId: 2
                        );*/


                      },
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
