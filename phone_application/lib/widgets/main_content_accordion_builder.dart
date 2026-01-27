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
import '../services/builders_screen.dart';
import 'accordion_widgets.dart';

// главный построитель контента в аккордионах медика, куратора и админа
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

  // конструктор для построения виджета аккордиона (тот, что содержит секции списком)
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

  // конструтор для построения списка секций для медика. Добавляются сначала сотрудники, потом - студенты
  List<AccordionSection> buildMedicListAccordionSections(BuildContext context) {
    BuildersScreen _BuildersScreen = BuildersScreen();
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
      // добавляем в список секцию с сотрудниками
      ...medicEntireCommunity!.where((item) => item.staffList.isNotEmpty).map((e) {
        final String uniqueStaffSectionId = 'id_staff_section';
        bool isEditing = false;
        bool isDatePickerOpened = false;
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
                      (staff) {
                        final uniqueStaffId = 'staff_${staff.id}_${staff.lastname}';
                        return BlocListener<WorkingWithFluorographyBloc, WorkingWithFluorographyState>(
                          listener: (context, state){
                            isDatePickerOpened = state.editingStates[uniqueStaffId] ?? false;
                            isDatePickerOpened ? _BuildersScreen.openDatePicker(context, uniqueStaffId, context.read<WorkingWithFluorographyBloc>()) : (){};
                          },
                          child: OneRowBuildAccordionSectionContentStaff(
                          staff: staff,
                          // uniqueStaffId: uniqueStaffId,
                          uniqueStaffId: uniqueStaffId,
                            uniqueEditingSectionId: uniqueStaffSectionId,
                        ),);
                        }),

                BlocBuilder<WorkingWithFluorographyBloc, WorkingWithFluorographyState>(
                  builder: (context, state){
                    isEditing = state.editingStates[uniqueStaffSectionId] ?? false;
                    //print('Перестраиваю виджет с id $uniqueStaffSectionId, изменяемость: $isEditing');
                    return _ScreensWidgets.EditRowWithButtons(context: context, uniqueId: uniqueStaffSectionId, isEditing: isEditing);
                  },
                )
                // BlocBuilder<WorkingWithFluorographyBloc, WorkingWithFluorographyState>(
                //   builder: (context, state){
                //     switch(state.runtimeType){
                //       case EditModeWorkingWithFluorographyState:
                //         return _ScreensWidgets.EditRowWithButtons(context: context);
                //       case CancelEditingModeEvent:
                //         return _ScreensWidgets.EditElevatedButton(context: context);
                //       case EnableEditingModeEvent:
                //         return _ScreensWidgets.EditElevatedButton(context: context);
                //       default:
                //         return _ScreensWidgets.EditElevatedButton(context: context);
                //     }
                //   },
                // )
                // _ScreensWidgets.EditElevatedButton(context: context),
              ]
          ),
        );
      }),

      // добавляем в список секции групп со студентами
      ...medicEntireCommunity!
          .where((item) => item.studentsList.isNotEmpty)
          .expand((groups) {
        return groups.studentsList.map((group) {
          final String uniqueGroupSectionId = 'id_group_${group.groupNumber}';
          bool isEditing = false;
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
                    final uniqueStudentId = 'student_${student.id}_${student.lastname}';
                    return OneRowBuildAccordionSectionContent(
                      student: student,
                      // uniqueId: uniqueStudentId,
                      uniqueId: uniqueStudentId,
                      uniqueEditingSectionId: uniqueGroupSectionId,
                    );
                  }),
                  BlocBuilder<WorkingWithFluorographyBloc, WorkingWithFluorographyState>(
                    builder: (context, state){
                      isEditing = state.editingStates[uniqueGroupSectionId] ?? false;
                      //print('Перестраиваю виджет с id $uniqueGroupSectionId, изменяемость: $isEditing');
                      return _ScreensWidgets.EditRowWithButtons(context: context, uniqueId: uniqueGroupSectionId, isEditing: isEditing);
                    },
                  )

                  // BlocBuilder<WorkingWithFluorographyBloc, WorkingWithFluorographyState>(
                  //   builder: (context, state){
                  //     switch(state.runtimeType){
                  //       case EditModeWorkingWithFluorographyState:
                  //         return _ScreensWidgets.EditRowWithButtons(context: context);
                  //       case CancelEditingModeEvent:
                  //         return _ScreensWidgets.EditElevatedButton(context: context);
                  //       case EnableEditingModeEvent:
                  //         return _ScreensWidgets.EditElevatedButton(context: context);
                  //       default:
                  //         return _ScreensWidgets.EditElevatedButton(context: context);
                  //     }
                  //   },
                  //
                  // )
                ]
            ),
          );
        });
      }),
      // ElevatedButton(onPressed: (){}, child: Text('Сис')),
    ];
  }

  // кнострутор для построения списка секций для куратора (только его группы)
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
      final String uniqueGroupSectionId = 'id_group_${groupData.groupNumber}';
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
                      (student) {
                        final uniqueStudentId = 'student_${student.id}_${student.lastname}';
                        return OneRowBuildAccordionSectionContent(
                          student: student,
                          uniqueId: uniqueStudentId,
                          uniqueEditingSectionId: uniqueGroupSectionId,
                        );
                      }
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
