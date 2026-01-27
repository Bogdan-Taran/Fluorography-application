import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/models/staff_model.dart';
import 'package:project_fluorography/models/student_model.dart';
import 'package:project_fluorography/widgets/screens_widgets.dart';
import '../models/staff_and_students_model.dart';

/*
class LazyAccordionSection extends StatefulWidget{
  final Widget header; //our headerAccordion widget
  final List<Widget> Function() contentBuilder; //function for init in first-start application
  final bool initiallyOpen; // boolean that shows that in init hearer will be closed

  LazyAccordionSection({
    required this.header,
    required this.contentBuilder,
    this.initiallyOpen = false,
  });

  @override
  _LazyAccordionSectionState createState() => _LazyAccordionSectionState();
}

class _LazyAccordionSectionState extends State<LazyAccordionSection>{
  bool isOpen = false;
  bool hasBuildContent = false;
  Widget? cachedContent;

  @override
  void initState(){
    super.initState();
    isOpen = widget.initiallyOpen;
  }

  @override
  Widget build(BuildContext context) {
    if(isOpen && !hasBuildContent){
      cachedContent = Column(
        children: widget.contentBuilder(),
      );
      hasBuildContent = true;
    }

    return AccordionSection(
      isOpen: isOpen,
      header: widget.header,
      content: isOpen && cachedContent != null ? cachedContent! : SizedBox.shrink(),
      // TODO: change to Bloc
      onOpenSection: () => setState(() {
        isOpen = true;
        if(!hasBuildContent){
          cachedContent = Column(
            children: widget.contentBuilder(),
          );
          hasBuildContent = true;
        }
      }),
      onCloseSection: () => setState(() => isOpen = false),
    );
  }
}
*/



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

/*
Widget BuildAccordionSectionContentMedic(
  BuildContext context,
  List<StaffAndStudentsModel> data,
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
                return staff.staffList.map((e) {
                    return OneRowBuildAccordionSectionContentStaff(
                        staff: e);
                });
              }).toList()
            :
                data.expand((groups) {
                  return groups.studentsList.expand((students) {
                    return students.students.map((student) {
                      final uniqueStudentId = 'student_${student.id}_${student.lastname}';
                        return OneRowBuildAccordionSectionContent(
                            student: student,
                          uniqueId: uniqueStudentId,
                        );
                    });
                  });
                }).toList()
        ),
      SizedBox(height: 15),
      ElevatedButton(
        onPressed: () {},
        child: Text('Редактировать'),
      ),
    ],
  );
}
*/


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
    ScreensWidgets _ScreensWidgets = ScreensWidgets();
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
          _ScreensWidgets.DataFluraContainer(context: context, dataContainer: dateFluraString!, uniqueDateContainerId: uniqueId, uniqueEditingSectionId: uniqueEditingSectionId)
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
    ScreensWidgets _ScreensWidgets = ScreensWidgets();

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
          _ScreensWidgets.DataFluraContainer(context: context, dataContainer: dateFluraString!, uniqueDateContainerId: uniqueStaffId, uniqueEditingSectionId: uniqueEditingSectionId)
        ],
      ),
    );
  }
}

