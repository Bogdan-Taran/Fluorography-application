import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/models/student_models.dart';
import '../bloc/events.dart';
import '../bloc/student_bloc.dart';
import '../widgets/animated_date_container.dart';
import 'date_edit_dialog.dart';

class StudentRowWidget extends StatelessWidget{
  final Student student;
  final bool isEditing;
  //final VoidCallback? onTap;
  final Function(Student, DateTime) onDateUpdate;

  const StudentRowWidget({
    Key? key,
    required this.student,
    required this.isEditing,
    required this.onDateUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    final dateStr = _formatDate(student.dateFluorography);
    final isOverdue = _isFluoroOverdue(student.dateFluorography);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Row(
                children: [
                  Text(student.lastname, style: _studentStyle,),
                  const SizedBox(width: 4,),
                  Text(student.firstname, style: _studentStyle,),
                  const SizedBox(width: 4,),
                  Expanded(
                      child: Text(student.patronymic, overflow: TextOverflow.ellipsis, style: _studentStyle,),
                  )
                ],
              )
          ),
          AnimatedDateContainer(
            dateStr: dateStr,
            isOverdue: isOverdue,
            isShaking: isEditing,
            onTap: isEditing ? () => _showDateEditDialog(context) : null,
          ),
        ],
      )
    );
  }


  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  bool _isFluoroOverdue(DateTime? date){
    if(date == null) return true;
    final validUntil = date.add(const Duration(days: 365));
    return DateTime.now().isAfter(validUntil);
  }

  void _showDateEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => DateEditDialog(
        currentDate: student.dateFluorography,
        onDateSelected: (newDate) {
          // Закрываем диалог
          Navigator.of(dialogContext).pop();
          // Вызываем callback для обновления даты
          onDateUpdate(student, newDate);
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }





  static const _studentStyle = TextStyle(
    color: Color(0xff26292B),
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: 'Geologica',
  );
  
}

class GroupHeaderWidget extends StatelessWidget{
  final String groupNumber;
  final int studentCount;

  const GroupHeaderWidget({
    Key? key,
    required this.groupNumber,
    required this.studentCount,
}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Row(
      children: [
        Text('Группа ${groupNumber}', style: _headerStyle),
        const SizedBox(width: 30,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xffF29393),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(studentCount.toString(), style: _countTextStyle),
              const SizedBox(width: 6,),
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

  static const _headerStyle = TextStyle(
    color: Color(0xff4482D2),
    fontSize: 16,
    fontWeight: FontWeight.w300,
    fontFamily: 'Geologica',
  );

  static const _countTextStyle = TextStyle(
    fontWeight: FontWeight.w300,
    color: Color(0xff26292B),
    fontFamily: 'Geologica',
    fontSize: 14,
  );
  
  
}
