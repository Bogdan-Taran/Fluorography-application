import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/models/staff_and_students_model.dart';
import 'package:project_fluorography/widgets/screens_widgets.dart';
import 'package:project_fluorography/screens/medic/controller/fluorography_controller.dart';
import '../services/checker_service.dart';
import '../styles.dart';
import 'accordion_widgets.dart';
import 'expansion_tile.dart' as expansion_tile;

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
class MedicConstructorAccordionBuildWidget extends ConsumerStatefulWidget {
  final List<StaffAndStudentsModel>? medicEntireCommunity;

  const MedicConstructorAccordionBuildWidget({
    super.key,
    required this.medicEntireCommunity,
  });

  @override
  ConsumerState<MedicConstructorAccordionBuildWidget> createState() => _MedicConstructorAccordionBuildWidgetState();
}

class _MedicConstructorAccordionBuildWidgetState extends ConsumerState<MedicConstructorAccordionBuildWidget> {
  final Map<String, bool> _isExpandedTile = {};

  @override
  Widget build(BuildContext context) {
    final fluorographyState = ref.watch(fluorographyControllerProvider);
    final checkerService = CheckerService();

    return Column(
      children: [
        // секция с сотрудниками
        ...widget.medicEntireCommunity!.where((item) => item.staffList.isNotEmpty).map((e) {
          final String uniqueStaffSectionId = 'id_staff_section';
          final isEditing = fluorographyState.editingStates[uniqueStaffSectionId] ?? false;
          
          // Определяем статус для всей секции сотрудников
          DataStatus sectionStatus = DataStatus.noOverdue;
          for (var staff in e.staffList) {
            final s = checkerService.isFluorographyOverdue(staff.fluorography);
            if (s == DataStatus.overdue) {
              sectionStatus = DataStatus.overdue;
              break;
            } else if (s == DataStatus.quitOverdue && sectionStatus != DataStatus.overdue) {
              sectionStatus = DataStatus.quitOverdue;
            }
          }

          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: expansion_tile.ExpansionTile(
              title: HeaderAccordionSectionWidgetBuild(
                title: 'Сотрудники',
                count: e.staffList.length,
                status: sectionStatus,
              ),
              collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  side: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1.w)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  side: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1.w)),
              trailing: SvgPicture.asset(
                _isExpandedTile[uniqueStaffSectionId] == true
                    ? 'assets/images/icon_expand_down2.svg'
                    : 'assets/images/icon_expand_right.svg',
              ),
              onExpansionChanged: (bool expanded) {
                setState(() {
                  _isExpandedTile[uniqueStaffSectionId] = expanded;
                });
              },
              children: [
                Container(
                  width: double.infinity,
                  padding: REdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: const Color(0x330088cc), width: 1.h))),
                  child: Text(
                    'Чтобы изменить дату флюорографии, выберите человека из списка.',
                    style: TextStyle(
                      color: AppStyle.activeBlueColorMain,
                      fontSize: AppStyle.fontSizeMediumMini_14,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Geologica',
                    ),
                  ),
                ),
                ...e.staffList.map((staff) {
                  final uniqueStaffId = '${staff.id}';
                  return Container(
                    padding: REdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: const Color(0x330088cc), width: 1.h))),
                    child: OneRowBuildAccordionSectionContentStaff(
                      staff: staff,
                      uniqueStaffId: uniqueStaffId,
                      uniqueEditingSectionId: uniqueStaffSectionId,
                    ),
                  );
                }),
              ],
            ),
          );
        }),

        // секции групп со студентами
        ...widget.medicEntireCommunity!.where((item) => item.studentsList.isNotEmpty).expand((groups) {
          return groups.studentsList.map((group) {
            final String uniqueGroupSectionId = 'id_group_${group.groupNumber}';
            final isEditing = fluorographyState.editingStates[uniqueGroupSectionId] ?? false;

            // Определяем статус для всей группы
            DataStatus groupStatus = DataStatus.noOverdue;
            for (var student in group.students) {
              final s = checkerService.isFluorographyOverdue(student.fluorography);
              if (s == DataStatus.overdue) {
                groupStatus = DataStatus.overdue;
                break;
              } else if (s == DataStatus.quitOverdue && groupStatus != DataStatus.overdue) {
                groupStatus = DataStatus.quitOverdue;
              }
            }

            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: expansion_tile.ExpansionTile(
                title: HeaderAccordionSectionWidgetBuild(
                  groupNumber: group.groupNumber,
                  count: group.students.length,
                  title: 'Группа',
                  status: groupStatus,
                ),
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1.w)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1.w)),
                trailing: SvgPicture.asset(
                  _isExpandedTile[uniqueGroupSectionId] == true
                      ? 'assets/images/icon_expand_down2.svg'
                      : 'assets/images/icon_expand_right.svg',
                ),
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _isExpandedTile[uniqueGroupSectionId] = expanded;
                  });
                },
                children: [
                  Container(
                    width: double.infinity,
                    padding: REdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: const Color(0x330088cc), width: 1.h))),
                    child: Text(
                      'Чтобы изменить дату флюорографии, выберите человека из списка.',
                      style: TextStyle(
                        color: AppStyle.activeBlueColorMain,
                        fontSize: AppStyle.fontSizeMediumMini_14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Geologica',
                      ),
                    ),
                  ),
                  ...group.students.map((student) {
                    final uniqueStudentId = '${student.id}';
                    return Container(
                      padding: REdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: const Color(0x330088cc), width: 1.h))),
                      child: OneRowBuildAccordionSectionContent(
                        student: student,
                        uniqueId: uniqueStudentId,
                        uniqueEditingSectionId: uniqueGroupSectionId,
                      ),
                    );
                  }),
                ],
              ),
            );
          });
        }),
      ],
    );
  }
}

class CuratorConstructorAccordionBuildWidget extends ConsumerStatefulWidget {
  final List<SingleGroupWithStudentsModel>? groups;

  const CuratorConstructorAccordionBuildWidget({
    super.key,
    required this.groups,
  });

  @override
  ConsumerState<CuratorConstructorAccordionBuildWidget> createState() => _CuratorConstructorAccordionBuildWidgetState();
}

class _CuratorConstructorAccordionBuildWidgetState extends ConsumerState<CuratorConstructorAccordionBuildWidget> {
  final Map<String, bool> _isExpandedTile = {};

  @override
  Widget build(BuildContext context) {
    final fluorographyState = ref.watch(fluorographyControllerProvider);
    final checkerService = CheckerService();

    return Column(
      children: widget.groups!.map((groupData) {
        final String uniqueGroupSectionId = 'id_group_${groupData.groupNumber}';
        final isEditing = fluorographyState.editingStates[uniqueGroupSectionId] ?? false;

        DataStatus groupStatus = DataStatus.noOverdue;
        for (var student in groupData.students) {
          final s = checkerService.isFluorographyOverdue(student.fluorography);
          if (s == DataStatus.overdue) {
            groupStatus = DataStatus.overdue;
            break;
          } else if (s == DataStatus.quitOverdue && groupStatus != DataStatus.overdue) {
            groupStatus = DataStatus.quitOverdue;
          }
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: expansion_tile.ExpansionTile(
            title: HeaderAccordionSectionWidgetBuild(
              title: 'Группа',
              count: groupData.students.length,
              groupNumber: groupData.groupNumber,
              status: groupStatus,
            ),
            collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1.w)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1.w)),
            trailing: SvgPicture.asset(
              _isExpandedTile[uniqueGroupSectionId] == true
                  ? 'assets/images/icon_expand_down2.svg'
                  : 'assets/images/icon_expand_right.svg',
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isExpandedTile[uniqueGroupSectionId] = expanded;
              });
            },
            children: [
              if (groupData.students.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('В этой группе нет студентов'),
                )
              else
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: REdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: const Color(0x330088cc), width: 1.h))),
                      child: Text(
                        'Чтобы изменить дату флюорографии, выберите человека из списка.',
                        style: TextStyle(
                          color: AppStyle.activeBlueColorMain,
                          fontSize: AppStyle.fontSizeMediumMini_14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Geologica',
                        ),
                      ),
                    ),
                    ...groupData.students.map((student) {
                      final uniqueStudentId = '${student.id}';
                      return Container(
                        padding: REdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: const Color(0x330088cc), width: 1.h))),
                        child: OneRowBuildAccordionSectionContent(
                          student: student,
                          uniqueId: uniqueStudentId,
                          uniqueEditingSectionId: uniqueGroupSectionId,
                        ),
                      );
                    }),
                  ],
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class AdminConstructorAccordionBuildWidget extends StatefulWidget {
  final List<SingleGroupWithStudentsModel>? groups;

  const AdminConstructorAccordionBuildWidget({super.key, required this.groups});

  @override
  State<AdminConstructorAccordionBuildWidget> createState() => _AdminConstructorAccordionBuildWidgetState();
}

class _AdminConstructorAccordionBuildWidgetState extends State<AdminConstructorAccordionBuildWidget> {
  final Map<String, bool> _isExpandedTile = {};

  @override
  Widget build(BuildContext context) {
    final checkerService = CheckerService();

    return Column(
      children: widget.groups!.map((groupData) {
        final String uniqueGroupSectionId = 'id_group_${groupData.groupNumber}';

        DataStatus groupStatus = DataStatus.noOverdue;
        for (var student in groupData.students) {
          final s = checkerService.isFluorographyOverdue(student.fluorography);
          if (s == DataStatus.overdue) {
            groupStatus = DataStatus.overdue;
            break;
          } else if (s == DataStatus.quitOverdue && groupStatus != DataStatus.overdue) {
            groupStatus = DataStatus.quitOverdue;
          }
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: expansion_tile.ExpansionTile(
            title: HeaderAccordionSectionWidgetBuild(
              title: 'Группа',
              count: groupData.students.length,
              groupNumber: groupData.groupNumber,
              status: groupStatus,
            ),
            collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1.w)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1.w)),
            trailing: SvgPicture.asset(
              _isExpandedTile[uniqueGroupSectionId] == true
                  ? 'assets/images/icon_expand_down2.svg'
                  : 'assets/images/icon_expand_right.svg',
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isExpandedTile[uniqueGroupSectionId] = expanded;
              });
            },
            children: [
              if (groupData.students.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('В этой группе нет студентов'),
                )
              else
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: REdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: const Color(0x330088cc), width: 1.h))),
                      child: Text(
                        'Список студентов группы с датами прохождения флюорографии.',
                        style: TextStyle(
                          color: AppStyle.activeBlueColorMain,
                          fontSize: AppStyle.fontSizeMediumMini_14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Geologica',
                        ),
                      ),
                    ),
                    ...groupData.students.map((student) {
                      final uniqueStudentId = '${student.id}';
                      return Container(
                        padding: REdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: const Color(0x330088cc), width: 1.h))),
                        child: OneRowBuildAccordionSectionContent(
                          student: student,
                          uniqueId: uniqueStudentId,
                          uniqueEditingSectionId: uniqueGroupSectionId,
                        ),
                      );
                    }),
                  ],
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
