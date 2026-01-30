import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/models/staff_model.dart';
import 'package:project_fluorography/models/student_model.dart';
import 'package:project_fluorography/widgets/screens_widgets.dart';
import '../models/staff_and_students_model.dart';

// констутор для построения шапок секций медика, куратора и админа
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

// конструтор для построения одной единицы строки для студентов
class OneRowBuildAccordionSectionContent extends StatelessWidget {
  final StudentData student;
  final String uniqueId;
  final String uniqueEditingSectionId;
  // final Function(StudentData, DateTime) dateFluorographyUpdate;

  const OneRowBuildAccordionSectionContent({
    Key? key,
    required this.student,
    required this.uniqueId,
    required this.uniqueEditingSectionId
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
          DataFluraContainerBuildWidget(uniqueEditingSectionId: uniqueEditingSectionId, dataContainer: dateFluraString!, uniqueDateContainerId: uniqueId, key: key,)
          // _ScreensWidgets.DataFluraContainer(context: context, dataContainer: dateFluraString!, uniqueDateContainerId: uniqueId, uniqueEditingSectionId: uniqueEditingSectionId)
        ],
      ),
    );
  }
}


// конструтор для построения одной единицы строки сотрудника
class OneRowBuildAccordionSectionContentStaff extends StatelessWidget {
  final StaffModel staff;
  final String uniqueStaffId;
  final String uniqueEditingSectionId;

  const OneRowBuildAccordionSectionContentStaff({
    Key? key,
    required this.staff,
    required this.uniqueStaffId,
    required this.uniqueEditingSectionId
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
          DataFluraContainerBuildWidget(uniqueDateContainerId: uniqueStaffId, dataContainer: dateFluraString!, uniqueEditingSectionId: uniqueEditingSectionId, key: key,)
          // _ScreensWidgets.DataFluraContainer(context: context, dataContainer: dateFluraString!, uniqueDateContainerId: uniqueStaffId, uniqueEditingSectionId: uniqueEditingSectionId)
        ],
      ),
    );
  }
}

