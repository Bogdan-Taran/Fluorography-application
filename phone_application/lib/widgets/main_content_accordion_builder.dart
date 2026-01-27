import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/models/staff_and_students_model.dart';
import 'package:project_fluorography/widgets/screens_widgets.dart';

import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../screens/curator_screen.dart';
import 'accordion_widgets.dart';

class MainContentAccordionBuilder extends StatelessWidget {
  final String role;
  final List<SingleGroupWithStudentsModel>? groups;
  final List<StaffAndStudentsModel>? medicEntireCommunity;
  ScreensWidgets _ScreensWidgets = ScreensWidgets();

  MainContentAccordionBuilder(
    BuildContext context, {
    Key? key,
    required this.role,
    this.groups,
    this.medicEntireCommunity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (medicEntireCommunity != null && medicEntireCommunity!.isNotEmpty) {
      return constructorAccordionBuild(
          children: buildMedicListAccordionSections(context)
      );
    } else if (groups != null && groups!.isNotEmpty) {
      return constructorAccordionBuild(children: buildCuratorListAccordionSections());
    } else {
      return Center(child: Text('Нет данных'));
    }
  }

  Widget constructorAccordionBuild({required List<AccordionSection> children}) {
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
      headerBorderRadius: 25,
      children: children,
    );
  }

  List<AccordionSection> buildMedicListAccordionSections(BuildContext context) {
    if(medicEntireCommunity == null || medicEntireCommunity!.isEmpty){
      return [
        AccordionSection(
        isOpen: false,
        paddingBetweenClosedSections: 30,
        paddingBetweenOpenSections: 30,
        header: Text('Без данных у медика'),
        contentHorizontalPadding: 12,
        contentVerticalPadding: 12,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          ],
        ),
      ),

      ];
    }
    return [
      ...medicEntireCommunity!.where((item) => item.staffList.isNotEmpty).map((
        e,
      ) {
        // TODO: change to lazy loading section
        return AccordionSection(
          isOpen: false,
          paddingBetweenClosedSections: 30,
          paddingBetweenOpenSections: 30,
          header: HeaderAccordionSectionWidgetBuild(
            title: 'Сотрудники',
            count: e.staffList.length,
          ),
          contentHorizontalPadding: 12,
          contentVerticalPadding: 12,
          content: Column(
            children: [
              ...e.staffList
                .map(
                  (staff) => OneRowBuildAccordionSectionContentStaff(
                    staff: staff,
                  ),).toList(),
                BlocBuilder<WorkingWithFluorographyBloc, WorkingWithFluorographyState>(
                  builder: (context, state){
                    switch(state.runtimeType){
                      case EditModeWorkingWithFluorographyState:
                        return _ScreensWidgets.EditRowWithButtons(context: context);
                      case CancelEditingModeEvent:
                        return _ScreensWidgets.EditElevatedButton(context: context);
                      case EnableEditingModeEvent:
                        return _ScreensWidgets.EditElevatedButton(context: context);
                      default:
                        return _ScreensWidgets.EditElevatedButton(context: context);
                    }
                  },
                )
              // _ScreensWidgets.EditElevatedButton(context: context),
                ]
          ),
        );
      }),
      ...medicEntireCommunity!
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
                  children: [
                    ...group.students.map((student) {
                    return OneRowBuildAccordionSectionContent(
                      student: student,
                    );
                  }),

                    BlocBuilder<WorkingWithFluorographyBloc, WorkingWithFluorographyState>(
                      builder: (context, state){
                        switch(state.runtimeType){
                          case EditModeWorkingWithFluorographyState:
                            return _ScreensWidgets.EditRowWithButtons(context: context);
                          case CancelEditingModeEvent:
                            return _ScreensWidgets.EditElevatedButton(context: context);
                          case EnableEditingModeEvent:
                            return _ScreensWidgets.EditElevatedButton(context: context);
                          default:
                            return _ScreensWidgets.EditElevatedButton(context: context);
                        }
                      },

                    )
                  ]
                ),
              );
            });
          }),
      // ElevatedButton(onPressed: (){}, child: Text('Сис')),
    ];
  }

  List<AccordionSection> buildCuratorListAccordionSections() {
    if(groups == null || groups!.isEmpty){
      return [
        AccordionSection(
        isOpen: false,
        paddingBetweenClosedSections: 30,
        paddingBetweenOpenSections: 30,
        header: Text('Без данных у куратора'),
        contentHorizontalPadding: 12,
        contentVerticalPadding: 12,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Нема')
          ],
        ),
      ),

      ];
    }
    return groups!.map((groupData) {
      return AccordionSection(
        isOpen: false,
        paddingBetweenClosedSections: 30,
        paddingBetweenOpenSections: 30,
        header: HeaderAccordionSectionWidgetBuild(
          title: 'Группа',
          count: groupData.students.length,
          groupNumber: groupData.groupNumber,
        ),
        contentHorizontalPadding: 12,
        contentVerticalPadding: 12,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (groupData.students.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('В этой группе нет студентов'),
              )
            else
              Column(
                children: groupData.students
                    .map(
                      (student) =>
                          OneRowBuildAccordionSectionContent(student: student),
                    )
                    .toList(),),
                SizedBox(height: 15),
                groupData.students.isEmpty ? SizedBox(height: 0,) :
                ElevatedButton(onPressed: () {}, child: Text('Редактировать')),
          ],
        ),
      );
    }).toList();
  }
}
