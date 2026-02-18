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
import 'accordion_widgets.dart';

// главный построитель контента в аккордионах медика, куратора и админа
class MainContentAccordionBuilder extends StatelessWidget {
  final String role;
  final List<SingleGroupWithStudentsModel>? groups;
  final List<StaffAndStudentsModel>? medicEntireCommunity;

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
      return MedicConstructorAccordionBuildWidget(
        medicEntireCommunity: medicEntireCommunity,
        key: key,
      );
    } else if (groups != null && groups!.isNotEmpty) {
      return CuratorConstructorAccordionBuildWidget(groups: groups, key: key);
    } else {
      return Center(child: Text('Нет данных'));
    }
  }
}

// строит аккордион со всеми вложенностями для медика
class MedicConstructorAccordionBuildWidget extends StatelessWidget {
  final List<StaffAndStudentsModel>? medicEntireCommunity;

  const MedicConstructorAccordionBuildWidget({
    super.key,
    required this.medicEntireCommunity,
  });

  @override
  Widget build(BuildContext context) {
    const lightBlueColor = Color(0xffD4EAFF);
    const whiteColor = Colors.white;
    return Accordion(
      headerBorderColor: lightBlueColor,
      headerBorderColorOpened: lightBlueColor,
      headerBorderWidth: 1,
      headerBackgroundColorOpened: Colors.transparent,
      headerBackgroundColor: whiteColor,
      rightIcon: SvgPicture.asset(
        'assets/images/icon_expand_down.svg',
        height: 14,
        width: 6,
      ),
      contentBackgroundColor: whiteColor,
      contentBorderColor: lightBlueColor,
      contentBorderWidth: 1,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      disableScrolling: true,
      headerPadding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      headerBorderRadius: 16,
      children: [
        // добавляем в список секцию с сотрудниками
        ...medicEntireCommunity!.where((item) => item.staffList.isNotEmpty).map((
          e,
        ) {
          final String uniqueStaffSectionId = 'id_staff_section';
          bool isEditing = false;
          return AccordionSection(
            isOpen: false,
            paddingBetweenClosedSections: 10,
            paddingBetweenOpenSections: 10,
            header: HeaderAccordionSectionWidgetBuild(
              title: 'Сотрудники',
              count: e.staffList.length,
            ),
            contentHorizontalPadding: 16,
            // contentVerticalPadding: 2,
            content: Column(
              children: [
                ...e.staffList.map((staff) {
                  // final uniqueStaffId = 'staff_${staff.id}_${staff.lastname}';
                  final uniqueStaffId = '${staff.id}';
                  return BlocListener<
                    WorkingWithFluorographyBloc,
                    WorkingWithFluorographyState
                  >(
                    listener: (context, state) {
                      // isDatePickerOpened ? _BuildersScreen.openDatePicker(context, uniqueStaffId, context.read<WorkingWithFluorographyBloc>()) : (){};
                    },
                    child: OneRowBuildAccordionSectionContentStaff(
                      staff: staff,
                      // uniqueStaffId: uniqueStaffId,
                      uniqueStaffId: uniqueStaffId,
                      uniqueEditingSectionId: uniqueStaffSectionId,
                    ),
                  );
                }),

                BlocBuilder<
                  WorkingWithFluorographyBloc,
                  WorkingWithFluorographyState
                >(
                  builder: (context, state) {
                    isEditing =
                        state.editingStates[uniqueStaffSectionId] ?? false;
                    //print('Перестраиваю виджет с id $uniqueStaffSectionId, изменяемость: $isEditing');
                    return EditRowWithButtons(
                      uniqueId: uniqueStaffSectionId,
                      isEditing: isEditing,
                      key: key,
                    );
                    // return _ScreensWidgets.EditRowWithButtons(context: context, uniqueId: uniqueStaffSectionId, isEditing: isEditing);
                  },
                ),
              ],
            ),
          );
        }),

        // добавляем в список секции групп со студентами
        ...medicEntireCommunity!.where((item) => item.studentsList.isNotEmpty).expand((
          groups,
        ) {
          return groups.studentsList.map((group) {
            final String uniqueGroupSectionId = 'id_group_${group.groupNumber}';
            bool isEditing = false;
            return AccordionSection(
              isOpen: false,
              paddingBetweenClosedSections: 10,
              paddingBetweenOpenSections: 10,
              header: HeaderAccordionSectionWidgetBuild(
                groupNumber: group.groupNumber,
                count: group.students.length,
                title: 'Группа',
              ),
              contentHorizontalPadding: 12,
              // contentVerticalPadding: 12,
              content: Column(
                children: [
                  ...group.students.map((student) {
                    final uniqueStudentId = '${student.id}';
                    return OneRowBuildAccordionSectionContent(
                      student: student,
                      uniqueId: uniqueStudentId,
                      uniqueEditingSectionId: uniqueGroupSectionId,
                    );
                  }),
                  BlocBuilder<
                    WorkingWithFluorographyBloc,
                    WorkingWithFluorographyState
                  >(
                    builder: (context, state) {
                      isEditing =
                          state.editingStates[uniqueGroupSectionId] ?? false;
                      //print('Перестраиваю виджет с id $uniqueGroupSectionId, изменяемость: $isEditing');
                      return EditRowWithButtons(
                        uniqueId: uniqueGroupSectionId,
                        isEditing: isEditing,
                        key: key,
                      );
                      // return _ScreensWidgets.EditRowWithButtons(context: context, uniqueId: uniqueGroupSectionId, isEditing: isEditing);
                    },
                  ),
                ],
              ),
            );
          });
        }),
      ],
    );
  }
}

class CuratorConstructorAccordionBuildWidget extends StatelessWidget {
  final List<SingleGroupWithStudentsModel>? groups;

  const CuratorConstructorAccordionBuildWidget({
    super.key,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    const lightBlueColor = Color(0xffD4EAFF);
    const whiteColor = Colors.white;
    return Accordion(
      headerBorderColor: lightBlueColor,
      headerBorderColorOpened: lightBlueColor,
      headerBorderWidth: 1,
      headerBackgroundColorOpened: Colors.transparent,
      headerBackgroundColor: whiteColor,
      rightIcon: SvgPicture.asset(
        'assets/images/icon_expand_down.svg',
        height: 14,
        width: 6,
      ),
      contentBackgroundColor: whiteColor,
      contentBorderColor: lightBlueColor,
      contentBorderWidth: 1,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      disableScrolling: true,
      headerPadding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      headerBorderRadius: 16,
      children: groups!.map((groupData) {
        bool isEditing = false;
        final String uniqueGroupSectionId = 'id_group_${groupData.groupNumber}';
        return AccordionSection(
          isOpen: false,
          paddingBetweenClosedSections: 10,
          paddingBetweenOpenSections: 10,
          header: HeaderAccordionSectionWidgetBuild(
            title: 'Группа',
            count: groupData.students.length,
            groupNumber: groupData.groupNumber,
          ),
          contentHorizontalPadding: 12,
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
                  children: [
                    ...groupData.students.map((student) {
                      // final uniqueStudentId = 'student_${student.id}_${student.lastname}';
                      final uniqueStudentId = '${student.id}';
                      return OneRowBuildAccordionSectionContent(
                        student: student,
                        uniqueId: uniqueStudentId,
                        uniqueEditingSectionId: uniqueGroupSectionId,
                      );
                    }),
                    BlocBuilder<WorkingWithFluorographyBloc, WorkingWithFluorographyState>(
                        builder: (context, state){
                          isEditing = state.editingStates[uniqueGroupSectionId] ?? false;
                          return EditRowWithButtons(uniqueId: uniqueGroupSectionId, isEditing: isEditing, key: key,);
                        }
                    )
                  ]
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class AdminConstructorAccordionBuildWidget extends StatelessWidget {
  final List<SingleGroupWithStudentsModel>? groups;

  const AdminConstructorAccordionBuildWidget({
    super.key,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    const lightBlueColor = Color(0xffD4EAFF);
    const whiteColor = Colors.white;
    return Accordion(
      headerBorderColor: lightBlueColor,
      headerBorderColorOpened: lightBlueColor,
      headerBorderWidth: 1,
      headerBackgroundColorOpened: Colors.transparent,
      headerBackgroundColor: whiteColor,
      rightIcon: SvgPicture.asset(
        'assets/images/icon_expand_down.svg',
        height: 14,
        width: 6,
      ),
      contentBackgroundColor: whiteColor,
      contentBorderColor: lightBlueColor,
      contentBorderWidth: 1,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      disableScrolling: true,
      headerPadding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      headerBorderRadius: 16,
      children: groups!.map((groupData) {
        bool isEditing = false;
        final String uniqueGroupSectionId = 'id_group_${groupData.groupNumber}';
        return AccordionSection(
          isOpen: false,
          paddingBetweenClosedSections: 10,
          paddingBetweenOpenSections: 10,
          header: HeaderAccordionSectionWidgetBuild(
            title: 'Группа',
            count: groupData.students.length,
            groupNumber: groupData.groupNumber,
          ),
          contentHorizontalPadding: 12,
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
                  children: [
                    ...groupData.students.map((student) {
                      // final uniqueStudentId = 'student_${student.id}_${student.lastname}';
                      final uniqueStudentId = '${student.id}';
                      return OneRowBuildAccordionSectionContent(
                        student: student,
                        uniqueId: uniqueStudentId,
                        uniqueEditingSectionId: uniqueGroupSectionId,
                      );
                    }),

                  ]
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
