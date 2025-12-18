import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../services/shared_pref_service.dart';
import '../styles.dart';

class CuratorScreen extends StatelessWidget {
  static String id = 'curator_screen';

  const CuratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyles textStyles = TextStyles();
    final UserSharedPreferences _userSharedPreferences =
        UserSharedPreferences();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        appBar: AppBarCurator(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: AccordionGeneralWidgetList(),
          ),
        ),
      ),
    );
  }
}


PreferredSizeWidget AppBarCurator() {
  return PreferredSize(
    preferredSize: Size.fromHeight(120.0),
    child: Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: AppBarCuratorContent(),
    ),
  );
}

class AppBarCuratorContent extends StatelessWidget {
  // final TextEditingController searchController;
  // const AppBarCuratorContent({
  //   Key? key,
  //   required this.searchController,
  // });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
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

                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
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
                    onPressed: () {},
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
            ],
          ),
        ),
      ],
    );
  }
}

Widget AccordionGeneralWidgetList() {
  return Accordion(
    headerBorderColor: const Color(0xffD4EAFF),
    headerBorderColorOpened: const Color(0xffD4EAFF),
    headerBorderWidth: 1,
    headerBackgroundColorOpened: Colors.transparent,
    headerBackgroundColor: Colors.white,
    rightIcon: SvgPicture.asset(
      'assets/images/icon_expand_down.svg',
      height: 14,
      width: 6,
    ),
    contentBackgroundColor: Colors.white,
    contentBorderColor: const Color(0xffD4EAFF),
    contentBorderWidth: 1,
    scaleWhenAnimating: true,
    openAndCloseAnimation: true,
    disableScrolling: true,
    headerPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
    sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
    sectionClosingHapticFeedback: SectionHapticFeedback.light,
    headerBorderRadius: 30,
    children: [

    ],
  )
}

