import 'package:accordion/accordion.dart';
import 'package:accordion/accordion_section.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '';

import '../../../login.dart';

class MedicScreen extends StatefulWidget {
  const MedicScreen({Key? key}) : super(key: key);

  @override
  State<MedicScreen> createState() => _MedicScreenState();
}

class _MedicScreenState extends State<MedicScreen> {
  TextEditingController searchController = TextEditingController();
  bool active = false;
  String exTitle = "Группа 321";

  static const headerStyle = TextStyle(
    color: Color(0xff4482D2),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const contentStyleHeader = TextStyle(
    color: Color(0xff999999),
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  static const contentStyle = TextStyle(
    color: Color(0xff999999),
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  static const loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';
  static const slogan =
      'Do not forget to play around with all sorts of colors, backgrounds, borders, etc.';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black54,
        // statusBarBrightness: Brightness.light,
        // statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: AppBarContent(),
          ),
        ),

        backgroundColor: Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              // Stack(
              //   children: [
              //     Align(
              //       alignment: Alignment.centerRight,
              //       child: SvgPicture.asset(
              //         'assets/images/vectorRight.svg',
              //         semanticsLabel: 'Top SVG Image',
              //         fit: BoxFit.fitWidth,
              //       ),
              //     ),
              //     Align(
              //       alignment: Alignment(0, 0.6),
              //       widthFactor: 1,
              //       child: SvgPicture.asset(
              //         'assets/images/vectorLine.svg',
              //         fit: BoxFit.fitWidth,
              //         width: MediaQuery.of(context).size.width * 1,
              //       ),
              //     ),
              //     Align(
              //       alignment: Alignment.bottomCenter,
              //       child: SvgPicture.asset(
              //         'assets/images/vectorBottom.svg',
              //         fit: BoxFit.fitWidth,
              //         width: MediaQuery.of(context).size.width * 1,
              //       ),
              //     ),
              //   ],
              // ),
              Accordion(
                headerBorderColor: Color(0xffD4EAFF),
                headerBorderColorOpened: Color(0xffD4EAFF),
                headerBorderWidth: 1,
                headerBackgroundColorOpened: Colors.transparent,
                headerBackgroundColor: Colors.white,
                rightIcon: Icon(
                  Icons.arrow_drop_down,
                  size: 50,
                  color: Color(0xffD4EAFF),
                ),
                contentBackgroundColor: Colors.white,
                contentBorderColor: Color(0xffD4EAFF),
                contentBorderWidth: 1,
                contentHorizontalPadding: 5,
                scaleWhenAnimating: true,
                openAndCloseAnimation: true,
                headerPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 35,
                ),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                headerBorderRadius: 30,
                children: [
                  AccordionSection(
                    isOpen: false,
                    paddingBetweenClosedSections: 30,
                    paddingBetweenOpenSections: 30,
                    header: Row(
                      children: [
                        const Text('Группа 312', style: headerStyle),
                        SizedBox(width: 30),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffF29393),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text('14', style: headerStyle),
                              Icon(Icons.man_outlined),
                            ],
                          ),
                        ),
                      ],
                    ),
                    contentHorizontalPadding: 40,
                    contentVerticalPadding: 20,
                    content: const StudentsFIODate(),
                  ),
                ],
              ),

              // Container(
              //   alignment: Alignment.topCenter,
              //   child: Column(
              //     children: [
              //       SizedBox(height: 20),
              //
              //       Container(
              //         color: Colors.lightBlueAccent,
              //         height: 800,
              //         child: Row(),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentsFIODate
    extends
        StatelessWidget //__
        {
  const StudentsFIODate({super.key});

  @override
  Widget build(context) //__
  {
    return Column(
      children: [

        ElevatedButton(onPressed: () {}, child: const Text('Submit')),
      ],
    );
  }
}

class RowStudentFIODate
    extends
    StatelessWidget //__
    {
  const RowStudentFIODate({super.key});

  @override
  Widget build(context) //__
  {
    return Row(
      children: [
        Text(
          'Усольцев Никита Сергеевич'
        ),
        
      ],
    )
    );
  }
}

//содержимое AppBar (кнопка уведомления и кнопка)
class AppBarContent extends StatelessWidget {
  AppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // кнопка уведомления
                  IconButton(
                    color: Color(0xff98BFF3),
                    iconSize: 45,
                    onPressed: () {},
                    icon: Icon(Icons.notifications_none_outlined),
                  ),

                  // кнопка выхода
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: WidgetStateProperty.resolveWith<double>((
                        Set<WidgetState> states,
                      ) {
                        return 0;
                      }),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return Color(0xffD5D6D7);
                        }
                        if (states.contains(WidgetState.pressed)) {
                          return Color(0xFF72A7EB);
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return Color(0xFFBADEFF);
                        }
                        return Color(0xff98BFF3);
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith<Color>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return Color(0xFF888888);
                        }
                        return Color(0xffffffff);
                      }),
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
                    child: Text(
                      'Выход',
                      style: TextStyle(
                        fontSize: ResponsiveSizes.getFontSizeMedium(
                          context,
                          baseSize: AppSizes.fontSizeMedium,
                        ),
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Geologica',
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                // controller: searchController,
                cursorColor: Color(0xff72A7EB),
                cursorHeight: 17,
                cursorWidth: 1.2,
                decoration: InputDecoration(
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xff98BFF3),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xff72A7EB), width: 2),
                  ),
                  hintText: 'Поиск',
                  hintStyle: TextStyle(
                    fontSize: ResponsiveSizes.getfontSizeSmall(
                      context,
                      baseSize: AppSizes.fontSizeSmall,
                    ),
                    color: Color(0xff999A9B),
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                ),
                keyboardType: TextInputType.text,
                // maxLength: 25,
                maxLines: 1,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                // obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Icon(Icons.search_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// classo
//
//
// class GetDataToExpansionCardFromApi {
//   int group_number;
//   String surname_student;
//   String name_student;
//   String patroymic;
//   String date_fluorography;
//   int number_of_students_in_group;
//
//
//
//
// }

// class OneCardToExpand extends StatelessWidget {
//   OneCardToExpand(
//   {@
//   required
//   this.title,
//     this.
//   })
//
//
//
//   OneCardToExpand({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column();
//   }
// }
