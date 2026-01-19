import 'dart:core';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/bloc/curator/curator_bloc.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/models/student_model.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../services/builders_screen.dart';
import '../services/shared_pref_service.dart';
import '../styles.dart';
import '../widgets/accordion_widgets.dart';

class CuratorScreen extends StatefulWidget {
  static String id = 'curator_screen';

  const CuratorScreen({super.key});

  @override
  State<CuratorScreen> createState() => _CuratorScreen();
}

class _CuratorScreen extends State<CuratorScreen> {
  final CuratorBloc curatorBloc = CuratorBloc();

  @override
  void initState() {
    curatorBloc.add(CuratorInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyles textStyles = TextStyles();
    final UserSharedPreferences _userSharedPreferences =
        UserSharedPreferences();
    BuildersScreen _buildersScreen = BuildersScreen();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.lightBlueAccent,
        appBar: AppBarCurator(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: BlocConsumer<CuratorBloc, CuratorState>(
              bloc: CuratorBloc(),
              listenWhen: (previous, current) => current is CuratorActionState,
              buildWhen: (previous, current) => current is! CuratorActionState,
              listener: (context, state) {
                if(state is CuratorLogOutSuccessfulState){
                  print('Отработало сосотояния выхода');
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));
                }
                else if(state is CuratorLogOutErrorState){
                  print('Ошибка при попытке выхода');
                }
                else if(state is CuratorFetchingLoadingState){
                  print('Загрузка при попытке выйти');
                  _buildersScreen.buildLoading();
                }
                else{
                  print('listenner вышел через else');
                }
              },
              builder: (context, state) {
                switch (state.runtimeType) {

                  case CuratorFetchingLoadingState():
                    return Center(
                      child: _buildersScreen.buildLoading(),
                    );
                  case CuratorFetchingErrorState():
                    return Center(
                      child: Text('Нет групп'),
                    );
                  case CuratorLoadedGroupsSuccessfulState:
                    final successState =
                        state as CuratorLoadedGroupsSuccessfulState;
                    return buildMainContent(
                      context,
                      successState.curatorGroups,
                    );
                  default:
                    return Container(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.transparent
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('У вас отстутствуют группы кураторства', style: TextStyle(fontSize: 18),),
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

PreferredSizeWidget AppBarCurator(BuildContext context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(MediaQuery.sizeOf(context).height * 0.09),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.09,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: AppBarCuratorContent(),
    ),
  );
}

class AppBarCuratorContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CuratorBloc curatorBloc = CuratorBloc();
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
      child: Row(
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
              foregroundColor: WidgetStateProperty.all(const Color(0xffffffff)),
              minimumSize: WidgetStateProperty.all(
                Size(MediaQuery.of(context).size.width * 0.1, 35),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            onPressed: () {
              curatorBloc.add(CuratorSignOutEvent());
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
    );
  }
}

Widget buildMainContent(
  BuildContext context,
  List<SingleGroupWithStudentsModel> groups,
) {
  bool isEditing = false;
  final bloc = context.read<WorkingWithFluorographyBloc>();
  if (bloc.state is WorkingWithFluorographyEditState) {
    final state = bloc.state as WorkingWithFluorographyEditState;
    isEditing = state.isEditing;
  }
  if (groups.isEmpty) {
    return Center(child: Text('Не данных для построения главного экрана'));
  }
  return AccordionGeneralWidgetList(context, groups, isEditing);
}

Widget AccordionGeneralWidgetList(
  BuildContext context,
  List<SingleGroupWithStudentsModel> groups,
  bool isEditing,
) {
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
    children: groups.map((groupData) {
      return AccordionSection(
        isOpen: false,
        paddingBetweenClosedSections: 30,
        paddingBetweenOpenSections: 30,
        header: HeaderAccordionSectionBuildWidget(
          groupNumber: groupData.groupNumber,
          countStudents: groupData.students.length,
        ),
        contentHorizontalPadding: 12,
        contentVerticalPadding: 12,
        content: buildAccordionSectionContentBuild(
          context,
          groupData.students,
          isEditing,
        ),
      );
    }).toList(),
  );
}

// построитель контента ОДНОЙ секции аккордиона
Widget buildAccordionSectionContentBuild(
  BuildContext context,
  List<StudentData> students,
  bool isEditing,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (students.isEmpty)
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Студенты не найдены'),
        )
      else
        Column(
          children: students
              .map(
                (student) => OneRowBuildAccordionSectionContent(
                  student: student,
                  isEditing: isEditing,
                ),
              )
              .toList(),
        ),
      SizedBox(height: 15),
      ElevatedButton(
        onPressed: () {
          if (isEditing) {
            context.read<WorkingWithFluorographyBloc>().add(
              CancelEditingModeEvent(),
            );
          } else {
            context.read<WorkingWithFluorographyBloc>().add(
              EnableEditingModeEvent(),
            );
          }
        },
        child: Text('Редактировать'),
      ),
    ],
  );
}
