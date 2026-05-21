import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_fluorography/models/staff_model.dart';
import 'package:project_fluorography/models/student_model.dart';
import 'package:project_fluorography/widgets/screens_widgets.dart';
import 'package:project_fluorography/styles.dart';
import 'package:project_fluorography/screens/medic/controller/fluorography_controller.dart';
import '../services/checker_service.dart';
import '../services/builders_screen.dart';
import '../services/converters_service.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';

// констутор для построения шапок секций медика, куратора и админа
class HeaderAccordionSectionWidgetBuild extends StatelessWidget {
  final String title;
  final int count;
  final String? groupNumber;
  final DataStatus? status;

  HeaderAccordionSectionWidgetBuild({
    Key? key,
    required this.title,
    required this.count,
    this.groupNumber,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isHighlighted = status == DataStatus.overdue || status == DataStatus.quitOverdue;
    
    return Row(
      children: [
        Text(
          groupNumber == null ? title : 'Группа $groupNumber',
          style: TextStyle(
            fontSize: AppStyle.fontSizeMedium_16,
            color: AppStyle.blueColorTextTitle,
            fontWeight: FontWeight.w500,
            fontFamily: 'Geologica',
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          decoration: status == DataStatus.overdue
              ? BoxDecoration(
                  color: AppStyle.redColorTag,
                  borderRadius: BorderRadius.circular(10.r),
                )
              : status == DataStatus.quitOverdue
                  ? BoxDecoration(
                      color: AppStyle.yellowColorTag,
                      borderRadius: BorderRadius.circular(10.r),
                    )
                  : BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppStyle.blackColorMain,
                        width: 1.w,
                      )),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  color: isHighlighted ? Colors.white : AppStyle.blackColorMain,
                  fontSize: AppStyle.fontSizeSmall_12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 5.w),
              SvgPicture.asset(
                'assets/images/people_icon.svg',
                height: 12.h,
                width: 12.w,
                colorFilter: ColorFilter.mode(
                  isHighlighted ? Colors.white : AppStyle.blackColorMain,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// конструтор для построения одной единицы строки для студентов
class OneRowBuildAccordionSectionContent extends ConsumerWidget {
  final StudentData student;
  final String uniqueId;
  final String uniqueEditingSectionId;

  const OneRowBuildAccordionSectionContent({
    Key? key,
    required this.student,
    required this.uniqueId,
    required this.uniqueEditingSectionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFluraString = student.fluorography;
    final checkerService = CheckerService();
    final status = checkerService.isFluorographyOverdue(dateFluraString);

    return ListTile(
      onTap: () {
        _showEditFluorographyDialog(context, ref, student.id, student.lastname, student.firstname, student.fluorography ?? "");
      },
      contentPadding: EdgeInsets.zero,
      title: Text(
        '${student.lastname} ${student.firstname} ${student.patronymic ?? ""}',
        style: TextStyle(
          fontSize: AppStyle.fontSizeMedium_16,
          color: AppStyle.blackColorMain,
          fontWeight: FontWeight.w500,
          fontFamily: 'Geologica',
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: DataFluraContainerBuildWidget(
            uniqueEditingSectionId: uniqueEditingSectionId,
            dataContainer: dateFluraString!,
            uniqueDateContainerId: uniqueId,
          ),
        ),
      ),
      trailing: (status == DataStatus.overdue || status == DataStatus.quitOverdue)
          ? SvgPicture.asset(
              'assets/icon/reference_warn.svg',
              width: 24.w,
              colorFilter: ColorFilter.mode(
                status == DataStatus.overdue ? AppStyle.redColorTag : AppStyle.yellowColorTag,
                BlendMode.srcIn,
              ),
            )
          : null,
    );
  }
}

// конструтор для построения одной единицы строки сотрудника
class OneRowBuildAccordionSectionContentStaff extends ConsumerWidget {
  final StaffModel staff;
  final String uniqueStaffId;
  final String uniqueEditingSectionId;

  const OneRowBuildAccordionSectionContentStaff({
    Key? key,
    required this.staff,
    required this.uniqueStaffId,
    required this.uniqueEditingSectionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFluraString = staff.fluorography;
    final checkerService = CheckerService();
    final status = checkerService.isFluorographyOverdue(dateFluraString);

    return ListTile(
      onTap: () {
        _showEditFluorographyDialog(context, ref, staff.id, staff.lastname, staff.firstname, staff.fluorography ?? "");
      },
      contentPadding: EdgeInsets.zero,
      title: Text(
        '${staff.lastname} ${staff.firstname} ${staff.patronymic ?? ""}',
        style: TextStyle(
          fontSize: AppStyle.fontSizeMedium_16,
          color: AppStyle.blackColorMain,
          fontWeight: FontWeight.w500,
          fontFamily: 'Geologica',
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: DataFluraContainerBuildWidget(
            uniqueDateContainerId: uniqueStaffId,
            dataContainer: dateFluraString!,
            uniqueEditingSectionId: uniqueEditingSectionId,
          ),
        ),
      ),
      trailing: (status == DataStatus.overdue || status == DataStatus.quitOverdue)
          ? SvgPicture.asset(
              'assets/icon/reference_warn.svg',
              width: 24.w,
              colorFilter: ColorFilter.mode(
                status == DataStatus.overdue ? AppStyle.redColorTag : AppStyle.yellowColorTag,
                BlendMode.srcIn,
              ),
            )
          : null,
    );
  }
}

void _showEditFluorographyDialog(BuildContext context, WidgetRef ref, int id, String lastname, String firstname, String currentDate) {
  showDialog(
    context: context,
    builder: (context) {
      String selectedDate = currentDate;
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              '$lastname $firstname',
              style: TextStyle(fontFamily: 'Geologica', fontSize: AppStyle.fontSizeMedium_16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Новая дата флюорографии:'),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () {
                    final dateNow = DateTime.now();
                    BottomPicker.date(
                      buttonContent: Text(
                        textAlign: TextAlign.center,
                        'Выбрать',
                        style: TextStyle(
                          fontSize: AppStyle.fontSizeMedium_16,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Geologica',
                        ),
                      ),
                      buttonStyle: BoxDecoration(
                        color: Color(0xff98BFF3),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      headerBuilder: (context) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Выберите дату',
                              style: TextStyle(
                                fontSize: AppStyle.fontSizeMedium_16,
                                color: Color(0xFF72A7EB),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Geologica',
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.close, size: 24.r),
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all(Color(0xFF72A7EB)),
                              ),
                            ),
                          ],
                        );
                      },
                      dateOrder: DatePickerDateOrder.dmy,
                      initialDateTime: DateTime.now(),
                      maxDateTime: DateTime.now(),
                      minDateTime: dateNow.subtract(Duration(days: 365 * 2)),
                      onSubmit: (index) {
                        setDialogState(() {
                          selectedDate = ConverterServices().convertDatePicker(index);
                        });
                      },
                      bottomPickerTheme: BottomPickerTheme.fluraPlate,
                    ).show(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppStyle.blueColorAdditional98BFF3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      ConverterServices().formatFluraDate(selectedDate),
                      style: TextStyle(
                        fontSize: AppStyle.fontSizeMedium_16,
                        fontFamily: 'Geologica',
                        color: AppStyle.blackColorMain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Отмена', style: TextStyle(color: AppStyle.blueColorAdditional98BFF3, fontFamily: 'Geologica')),
              ),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(fluorographyControllerProvider.notifier).updateSingleFluorography(id, selectedDate);
                  Navigator.pop(context);
                  showPopMessage(context, 'Изменения сохранены', true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.blueColorAdditional98BFF3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                child: Text('Сохранить', style: TextStyle(color: Colors.white, fontFamily: 'Geologica')),
              ),
            ],
          );
        },
      );
    },
  );
}
