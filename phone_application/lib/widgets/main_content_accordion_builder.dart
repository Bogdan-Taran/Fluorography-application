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
      return MedicConstructorAccordionBuildWidget(medicEntireCommunity: medicEntireCommunity, key: key,);
    } else if (groups != null && groups!.isNotEmpty) {
      return CuratorConstructorAccordionBuildWidget(groups: groups, key: key,);
    } else {
      return Center(child: Text('Нет данных'));
    }
  }
}




// строит аккордион со всеми вложенностями для медика
class MedicConstructorAccordionBuildWidget extends StatelessWidget{
  final List<StaffAndStudentsModel>? medicEntireCommunity;
  const MedicConstructorAccordionBuildWidget({super.key, required this.medicEntireCommunity});

  @override
  Widget build(BuildContext context) {
    ScreensWidgets _ScreensWidgets = ScreensWidgets();
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
      children:
        [
      // добавляем в список секцию с сотрудниками
      ...medicEntireCommunity!.where((item) => item.staffList.isNotEmpty).map((e) {
        final String uniqueStaffSectionId = 'id_staff_section';
        bool isEditing = false;
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
                      // final uniqueStaffId = 'staff_${staff.id}_${staff.lastname}';
                      final uniqueStaffId = '${staff.id}';
                      return BlocListener<WorkingWithFluorographyBloc, WorkingWithFluorographyState>(
                        listener: (context, state){
                          // isDatePickerOpened ? _BuildersScreen.openDatePicker(context, uniqueStaffId, context.read<WorkingWithFluorographyBloc>()) : (){};
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
                    return EditRowWithButtons(uniqueId: uniqueStaffSectionId, isEditing: isEditing, key: key,);
                    // return _ScreensWidgets.EditRowWithButtons(context: context, uniqueId: uniqueStaffSectionId, isEditing: isEditing);
                  },
                )
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
                      return EditRowWithButtons(uniqueId: uniqueGroupSectionId, isEditing: isEditing, key: key,);
                      // return _ScreensWidgets.EditRowWithButtons(context: context, uniqueId: uniqueGroupSectionId, isEditing: isEditing);
                    },
                  )

                ]
            ),
          );
        });
      }),
    ]
    );
  }
}

class CuratorConstructorAccordionBuildWidget extends StatelessWidget{
  final List<SingleGroupWithStudentsModel>? groups;
  const CuratorConstructorAccordionBuildWidget({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
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
      children: groups!.map((groupData) {
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
                        // final uniqueStudentId = 'student_${student.id}_${student.lastname}';
                        final uniqueStudentId = '${student.id}';
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
      }).toList()
    );
  }
}
