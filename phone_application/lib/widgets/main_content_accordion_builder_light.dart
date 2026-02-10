import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/models/student_model.dart';
import 'package:project_fluorography/widgets/screens_widgets.dart';

import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../models/staff_and_students_model.dart';
import '../models/staff_model.dart';
import 'accordion_widgets.dart';

abstract class MedicDisplayItem {}

class StaffSection implements MedicDisplayItem {
  final String title;
  final int count;
  final List<StaffModel> staffList;

  StaffSection({
    required this.title,
    required this.count,
    required this.staffList,
  });
}

class GroupSection implements MedicDisplayItem {
  final String title;
  final int count;
  final String groupNumber;
  final List<StudentData> students;

  GroupSection({
    required this.title,
    required this.count,
    required this.groupNumber,
    required this.students,
  });
}

class MedicConstructorAccordionBuildWidgetLight extends StatelessWidget {
  final List<MedicDisplayItem>? displayItems;

  const MedicConstructorAccordionBuildWidgetLight({
    super.key,
    required this.displayItems,
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
      children: displayItems!
          .map((item) => buildAccordionSection(item))
          .toList(),
    );
  }

  AccordionSection buildAccordionSection(MedicDisplayItem item) {
    if (item is StaffSection) {
      return AccordionSection(
        header: HeaderAccordionSectionWidgetBuild(
          title: item.title,
          count: item.count,
        ),
        content: Column(
          children: [
            ...item.staffList.map(
              (staff) => OneRowBuildAccordionSectionContentStaff(
                staff: staff,
                uniqueStaffId: staff.id.toString(),
                uniqueEditingSectionId: 'staff_section',
              ),
            ),
          ],
        ),
      );
    } else if (item is GroupSection) {
      return AccordionSection(
        header: HeaderAccordionSectionWidgetBuild(
          title: item.title,
          count: item.count,
        ),
        content: Column(
          children: [
            ...item.students.map(
              (student) => OneRowBuildAccordionSectionContent(
                student: student,
                uniqueId: student.id.toString(),
                uniqueEditingSectionId: item.groupNumber,
              ),
            ),
          ],
        ),
      );
    }
    return AccordionSection(header: Text('Неизвестно'), content: SizedBox());
  }
}
