import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/models/staff_model.dart';
import 'package:project_fluorography/models/student_model.dart';

import '../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../models/staff_and_students_model.dart';
import '../services/builders_screen.dart';
import '../services/checker_service.dart';
import '../services/converters_service.dart';


class HeaderAccordionSectionWidgetBuild extends StatelessWidget{
  final String title;
  final int count;
  final String? groupNumber;

  HeaderAccordionSectionWidgetBuild({
    Key? key,
    required this.title,
    required this.count,
    this.groupNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          groupNumber == null? title : 'Группа $groupNumber'
        ),
        SizedBox(width: 30),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xffF29393),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(count.toString()),
              SizedBox(width: 6),
              SvgPicture.asset(
                'assets/images/people_icon.svg',
                height: 12,
                width: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }
}


Widget BuildAccordionSectionContentMedic(
  BuildContext context,
  List<StaffAndStudentsModel> data,
  bool isEditing,
    String role,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (data.isEmpty)
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Студенты не найдены'),
        )
      else
        Column(
          children: role == 'staff' ?
              data.expand((staff) {
                return staff.staffList.map((e) =>
                    OneRowBuildAccordionSectionContentStaff(
                        staff: e, isEditing: isEditing));
              }).toList()
            :
                data.expand((groups) {
                  return groups.studentsList.expand((students) {
                    return students.students.map((student) =>
                        OneRowBuildAccordionSectionContent(
                            student: student, isEditing: isEditing));
                  });
                }).toList()
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


// одна строка для построения
class OneRowBuildAccordionSectionContent extends StatelessWidget {
  final StudentData student;
  final bool isEditing;
  // final Function(StudentData, DateTime) dateFluorographyUpdate;

  const OneRowBuildAccordionSectionContent({
    Key? key,
    required this.student,
    required this.isEditing,
    // required this.dateFluorographyUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final dateFluraString = student.fluorography;

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Row(
                children: [
                  Text(student.lastname),
                  SizedBox(width: 4,),
                  Text(student.firstname),
                  SizedBox(width: 4,),
                  Expanded(child: Text(student.patronymic ?? 'Без отчества',
                    overflow: TextOverflow.ellipsis,),),
                ],
              )
          ),
          Container(
            child: Text(dateFluraString!),
          )
        ],
      ),
    );
  }
}


// одна строка для построения сотрудника
class OneRowBuildAccordionSectionContentStaff extends StatelessWidget {
  final StaffModel staff;
  final bool isEditing;

  const OneRowBuildAccordionSectionContentStaff({
    Key? key,
    required this.staff,
    required this.isEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final dateFluraString = staff.fluorography;

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Row(
                children: [
                  Text(staff.lastname),
                  SizedBox(width: 4,),
                  Text(staff.firstname),
                  SizedBox(width: 4,),
                  Expanded(child: Text(staff.patronymic ?? 'Без отчества',
                    overflow: TextOverflow.ellipsis,),),
                ],
              )
          ),
          Container(
            child: Text(dateFluraString!),
          )
        ],
      ),
    );
  }

}

