import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/bloc/medic/medic_bloc.dart';
import 'package:project_fluorography/models/staff_and_students_model.dart';
import 'package:project_fluorography/screens/sign_in.dart';

import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../services/builders_screen.dart';
import '../services/shared_pref_service.dart';
import '../styles.dart';
import '../widgets/accordion_widgets.dart';
import '../widgets/main_content_accordion_builder.dart';
import '../widgets/screens_widgets.dart';

class MedicScreen extends StatefulWidget {
  static String id = 'medic_screen';

  const MedicScreen({super.key});

  @override
  State<MedicScreen> createState() => _MedicScreen();
}

class _MedicScreen extends State<MedicScreen> {
  @override
  void initState() {
    (context).read<MedicBloc>().add(MedicInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyles textStyles = TextStyles();
    final UserSharedPreferences _userSharedPreferences =
    UserSharedPreferences();
    BuildersScreen _buildersScreen = BuildersScreen();

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.lightBlueAccent,
        appBar: AppBarMedic(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: BlocConsumer<MedicBloc, MedicState>(
              listenWhen: (previous, current) => current is! MedicActionState,
              buildWhen: (previous, current) => current is! MedicActionState,
              listener: (context, state) {
                switch (state.runtimeType) {
                  case MedicLogoutSuccessfulState:
                    print('Отработало сосотояния выхода');
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => SignInScreen()));
                    break;
                  case MedicLogoutErrorState:
                    print('Ошибка при попытке выхода');
                    break;
                  case MedicFetchingLoadingState:
                    _buildersScreen.buildLoading();
                    print('Загрузка выхода');
                    break;

                  case MedicOpenDatePickerState:
                    _buildersScreen.openDatePicker(context);
                    break;
                  case MedicCloseDatePickerState:
                    Navigator.of(context).pop();
                }
              },
              builder: (context, state) {
                switch (state.runtimeType) {
                  case MedicFetchingLoadingState:
                    return Center(child: _buildersScreen.buildLoading());
                  case MedicFetchingErrorState:
                    return Center(child: Text('Произошла ошибка'));
                  case MedicLoadedCommunitySuccessfulState:
                    final successfulState =
                    state as MedicLoadedCommunitySuccessfulState;
                    print('Печатаю лист');
                    print(successfulState.medicEntireCommunity);
                    // return buildMainContentMedic(
                    //   context,
                    //   successfulState
                    //       .medicEntireCommunity, //список с отдельным списком сотрудников и студентов
                    // );
                    return MainContentAccordionBuilder(context, role: 'medic', medicEntireCommunity: successfulState.medicEntireCommunity,);

                  default:
                    return Container(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 1,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.8,
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'У вас отсутствуют какие-либо люди в списках. Сисимасиси',
                            style: TextStyle(fontSize: 18),
                          ),
                          ElevatedButton(onPressed: () {
                            context.read<MedicBloc>().add(MedicOpenDatePickerEvent());
                            print('Нажата кнопка выбора даты');
                          }, child: Text('Выбор даты'))
                        ],
                      ),
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget AppBarMedic(BuildContext context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(MediaQuery
        .sizeOf(context)
        .height * 0.09),
    child: Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.09,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: AppBarMedicContent(),
    ),
  );
}

class AppBarMedicContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreensWidgets _ScreensWidgets = ScreensWidgets();
    return Padding(
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
                      Set<WidgetState> states,) {
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
                  foregroundColor: WidgetStateProperty.all(const Color(0xffffffff)),
                  minimumSize: WidgetStateProperty.all(
                    Size(MediaQuery
                        .of(context)
                        .size
                        .width * 0.1, 35),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                onPressed: () {
                  context.read<MedicBloc>().add(MedicLogoutEvent());
                  print('Нажата кнопка выхода');
                },
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
          SizedBox(height: 10),
          _ScreensWidgets.SearchBar(context: context)
        ],
      ),
    );
  }
}
/*
Widget buildMainContentMedic(BuildContext context,
    List<StaffAndStudentsModel> medicEntireCommunity,) {
  bool isEditing = false;

  if (medicEntireCommunity.isEmpty) {
    return Center(child: Text('Не данных для построения главного экрана'));
  }
  return AccordionGeneralWidgetListMedic(
    context,
    medicEntireCommunity,
    isEditing,
  );
}

Widget AccordionGeneralWidgetListMedic(BuildContext context,
    List<StaffAndStudentsModel> medicEntireCommunity,
    bool isEditing,) {

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
      ...medicEntireCommunity.where((item) => item.staffList.isNotEmpty).map((
          e,) {
        return AccordionSection(
          isOpen: false,
          paddingBetweenClosedSections: 30,
          paddingBetweenOpenSections: 30,
          header: HeaderAccordionSectionWidgetBuild(
              title: 'Сотрудники',
              count: e.staffList.length
          ),
          contentHorizontalPadding: 12,
          contentVerticalPadding: 12,
          content: Column(
            children: e.staffList
                .map(
                  (staff) =>
                  OneRowBuildAccordionSectionContentStaff(
                    staff: staff,
                    isEditing: isEditing,
                  ),
            )
                .toList(),
          ),
        );
      }),
      ...medicEntireCommunity
          .where((item) => item.studentsList.isNotEmpty)
          .expand((groups) {
        return groups.studentsList.map((group) {
          return AccordionSection(
              isOpen: false,
              paddingBetweenClosedSections: 30,
              paddingBetweenOpenSections: 30,
              header: HeaderAccordionSectionWidgetBuild(
                groupNumber: group.groupNumber,
                count: group.students.length,
                title: 'Группа',
              ),
              contentHorizontalPadding: 12,
              contentVerticalPadding: 12,
              content: Column(
                  children:
                  group.students.map((student) {
                    return OneRowBuildAccordionSectionContent(
                      student: student,
                      isEditing: isEditing,
                    );
                  }).toList()
              )
          );
        });
      })
    ],
  );

}
*/