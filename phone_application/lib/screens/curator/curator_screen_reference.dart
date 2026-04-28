import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:project_fluorography/bloc/curator/curator_bloc.dart';
import 'package:project_fluorography/bloc/internet_connect/interner_connect_cubit.dart';
import 'package:project_fluorography/models/single_group_with_students_model.dart';
import 'package:project_fluorography/styles.dart';
import 'package:talker/talker.dart';
import '../../bloc/working_with_fluorography/working_with_fluorography_bloc.dart';
import '../../main.dart';
import '../../models/get_reference_model/get_reference_model.dart';
import '../../services/api_reference/request_reference_controller.dart';
import '../../services/api_service_get_community_members.dart';
import '../../services/builders_screen.dart';
import '../../services/localDataBase.dart';
import '../../widgets/expansion_tile.dart' as expansion_tile;
import '../../widgets/main_content_accordion_builder.dart';


class CuratorScreenReference extends ConsumerStatefulWidget{
  const CuratorScreenReference({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CuratorScreenReference();
}
class _CuratorScreenReference extends ConsumerState{
  final Map<int, bool> _isExpandedTile = {};
  @override
  Widget build(BuildContext context) {
    final groupedData = ref.watch(groupedApplicationsByGroup);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final BuildersScreen _BuildersScreen = BuildersScreen();
    final List<String> itemsStatusId = [
      'В процессе',
      'Готово',
      'Дубликат',
    ];
    final valueListenable = ValueNotifier<String?>(null);
    bool editStatusMode = false;
    final talker = Talker();


    ref.listen<AsyncValue<void>>(updateReferenceStatusControllerProvider, (previous, next) {
      next.whenOrNull(
          error: (error, stack) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Ошибка'),
                content: Text(error.toString()),
              ),
            );
          },
          data: (_){
            showDialog(
                context: context,
                builder: (context)=> AlertDialog(
                  title: Text('Успешно'),
                  content: Text('Статус успешно изменен'),
                )
            );
          }
      );
    });

    return Scaffold(
      backgroundColor: AppStyle.whiteColorMain,
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: IgnorePointer(
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(1, -1),
                    child: SvgPicture.asset(
                      'assets/images/vectorRight.svg',
                      semanticsLabel: 'Top SVG Image',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Align(
                    alignment: const Alignment(1, 0.5),
                    child: SvgPicture.asset(
                      'assets/images/vectorLine.svg',
                      semanticsLabel: 'Top SVG Image',
                      fit: BoxFit.fill,
                      width: screenWidth,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(
                      'assets/images/vectorBottom.svg',
                      fit: BoxFit.fitWidth,
                      width: screenWidth,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: groupedData.when(
                data: (data) {
                  final groups = data.keys.toList();
                  if (groups.isEmpty) return const Center(child: Text('Нет справок'));
                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final groupName = groups[index];
                      final students = data[groupName]!;

                      final bool groupHasActiveReferences =
                          students.any((s) => s.status_id == 1);
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: expansion_tile.ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Группа $groupName',
                                style: TextStyle(
                                  color: AppStyle.blueColorTextTitle,
                                  fontSize: AppStyle.fontSizeMedium_16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                decoration: groupHasActiveReferences
                                    ? BoxDecoration(
                                        color: AppStyle.redColorTag,
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    : BoxDecoration(
                                        color: AppStyle.blueColorAdditional4AABDB,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${students.length}',
                                          style: TextStyle(
                                            color: AppStyle.whiteColorMain,
                                            fontSize: AppStyle.fontSizeSmall_12,
                                          )),
                                      SvgPicture.asset(
                                        'assets/images/people_icon.svg',
                                        color: AppStyle.whiteColorMain,
                                      )
                                    ]),
                              )
                            ],
                          ),
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: AppStyle.collapsedBlueColorD4EAFF, width: 1)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: AppStyle.collapsedBlueColorD4EAFF, width: 1)),
                          trailing: SvgPicture.asset(
                            _isExpandedTile[index] == true
                                ? 'assets/images/icon_expand_down2.svg'
                                : 'assets/images/icon_expand_right.svg',
                          ),
                          onExpansionChanged: (bool expanded) {
                            setState(() {
                              _isExpandedTile[index] = expanded;
                            });
                          },
                          children: students.map((student) {
                            return Container(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color(0x330088cc), width: 1))),
                              child: ListTile(
                                contentPadding: EdgeInsetsGeometry.symmetric(
                                    vertical: screenHeight * 0.0015),
                                title: Text(
                                  '${student.firstname} ${student.lastname}',
                                  style: TextStyle(
                                    color: AppStyle.blackColorMain,
                                    fontSize: AppStyle.fontSizeMedium_16,
                                  ),
                                ),
                                trailing: (student.status_id == 1)
                                    ? SvgPicture.asset(
                                        'assets/icon/reference_warn.svg',
                                        width: screenWidth * 0.05,
                                      )
                                    : SizedBox(),
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          contentPadding: EdgeInsets.zero,
                                          titlePadding: EdgeInsets.zero,
                                          title: Stack(
                                            children: [
                                              Container(
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          color: AppStyle
                                                              .collapsedBlueColorD4EAFF,
                                                          width: 1),
                                                    ),
                                                    color: const Color(0xffffffff),
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(50),
                                                      topRight: Radius.circular(50),
                                                    )),
                                                padding: EdgeInsets.only(
                                                    bottom: 10, top: 32, left: 32),
                                                // width: screenWidth * 0.02,
                                                child: Text(
                                                  'История справок',
                                                  style: TextStyle(
                                                    fontSize:
                                                        AppStyle.fontSizeExtraLarge,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppStyle.blackColorMain,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 20,
                                                top: 20,
                                                child: IconButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: AppStyle
                                                        .blueColorAdditional4AABDB,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xffFDFDFD),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(50),
                                                  bottomRight: Radius.circular(50),
                                                )),
                                            padding: EdgeInsetsGeometry.only(
                                                left: 32, right: 32, bottom: 32),
                                            child: SizedBox(
                                              width: double.maxFinite,
                                              height: screenHeight * 0.3,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    contentPadding: EdgeInsets.zero,
                                                    title: Text(
                                                      '${student.lastname} ${student.firstname} ${student.patronymic}',
                                                      style: TextStyle(
                                                          color: AppStyle
                                                              .blueColorTextTitle),
                                                    ),
                                                    subtitle: Text(
                                                        'группа ${student.group}, ${student.phone}'),
                                                  ),
                                                  Expanded(
                                                    child: Consumer(builder:
                                                        (context, ref, child) {
                                                      final historyDataAsync = ref.watch(
                                                          fetchStudentApplications(
                                                              student.user_id));
                                                      return historyDataAsync.when(
                                                          data: (data) {
                                                            if (data.isEmpty) {
                                                              return Text(
                                                                'У этого студента нет истории заявок',
                                                                style: TextStyle(
                                                                    color: AppStyle
                                                                        .blackColorMain,
                                                                    fontSize: AppStyle
                                                                        .fontSizeSmall_12),
                                                              );
                                                            }
                                                            return ListView.builder(
                                                                padding: EdgeInsets.zero,
                                                                itemCount: data.length,
                                                                itemBuilder:
                                                                    (context, index) {
                                                                  final item =
                                                                      data[index];
                                                                  return Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border: Border(
                                                                                bottom: BorderSide(
                                                                                    color: AppStyle
                                                                                        .collapsedBlueColorD4EAFF,
                                                                                    width:
                                                                                        1))),
                                                                    child: ListTile(
                                                                        contentPadding:
                                                                            EdgeInsets
                                                                                .zero,
                                                                        title: Text(
                                                                            item.type_id
                                                                                .applicationTypeName,
                                                                            style: TextStyle(
                                                                                color: AppStyle
                                                                                    .blackColorMain,
                                                                                fontSize:
                                                                                    AppStyle.fontSizeMediumMini_14,
                                                                                fontWeight:
                                                                                    FontWeight.w500)),
                                                                        subtitle: Text(
                                                                            item.date,
                                                                            style: TextStyle(
                                                                                color: AppStyle
                                                                                    .blueColorTextTitle,
                                                                                fontSize:
                                                                                    AppStyle.fontSizeSmall_12,
                                                                                fontWeight:
                                                                                    FontWeight.w500)),
                                                                        trailing:
                                                                            DropdownButtonHideUnderline(
                                                                          child:
                                                                              DropdownButton2<
                                                                                  String>(
                                                                            isExpanded:
                                                                                true,
                                                                            hint:
                                                                                Container(
                                                                              padding:
                                                                                  EdgeInsetsGeometry.symmetric(
                                                                                      vertical: 1,
                                                                                      horizontal: 8),
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                      color: item.status_id.statusColor,
                                                                                      borderRadius: BorderRadius.circular(10)),
                                                                              child: Text(
                                                                                  item.status_id.statusName,
                                                                                  style: TextStyle(
                                                                                      color: AppStyle.whiteColorMain,
                                                                                      fontSize: AppStyle.fontSizeSmall_12,
                                                                                      fontWeight: FontWeight.w500)),
                                                                            ),
                                                                            items: itemsStatusId
                                                                                .map((String
                                                                                        itemStatus) =>
                                                                                    DropdownItem<String>(
                                                                                        value: itemStatus,
                                                                                        height: 40,
                                                                                        child: Container(
                                                                                          padding: EdgeInsetsGeometry.symmetric(vertical: 1, horizontal: 8),
                                                                                          decoration: BoxDecoration(color: AppStyle.collapsedBlueColorD4EAFF, borderRadius: BorderRadius.circular(10)),
                                                                                          child: Text(itemStatus, style: TextStyle(color: AppStyle.whiteColorMain, fontSize: AppStyle.fontSizeSmall_12, fontWeight: FontWeight.w500)),
                                                                                        )))
                                                                                .toList(),
                                                                            onChanged:
                                                                                (value) {
                                                                              valueListenable
                                                                                      .value =
                                                                                  value;
                                                                            },
                                                                            buttonStyleData:
                                                                                ButtonStyleData(
                                                                                    height:
                                                                                        20,
                                                                                    width:
                                                                                        120),
                                                                            iconStyleData:
                                                                                const IconStyleData(
                                                                              icon: Icon(
                                                                                Icons
                                                                                    .arrow_forward_ios_outlined,
                                                                              ),
                                                                              iconSize: 16,
                                                                              iconEnabledColor:
                                                                                  AppStyle
                                                                                      .blueColorAdditional4AABDB,
                                                                              iconDisabledColor:
                                                                                  Colors
                                                                                      .grey,
                                                                            ),
                                                                          ),
                                                                        )),
                                                                  );
                                                                });
                                                          },
                                                          error: (error, stack) =>
                                                              Center(
                                                                  child: Text(
                                                                      'Ошибка загрузки: $error')),
                                                          loading: () => Center(
                                                                child:
                                                                    LoadingAnimationWidget
                                                                        .halfTriangleDot(
                                                                  color: AppStyle
                                                                      .blueColorAdditional4AABDB,
                                                                  size: 50,
                                                                ),
                                                              ));
                                                    }),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  editStatusMode
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    editStatusMode =
                                                                        false;
                                                                  });
                                                                },
                                                                child: Text('Отменить')),
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    editStatusMode =
                                                                        false;
                                                                  });
                                                                },
                                                                child: Text('Сохранить')),
                                                          ],
                                                        )
                                                      : ElevatedButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              editStatusMode = true;
                                                            });
                                                            talker.log(
                                                                'SecretaryScreen: setstate сработал');
                                                          },
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                WidgetStateProperty
                                                                    .resolveWith<Color>((
                                                              Set<WidgetState>
                                                                  states,
                                                            ) {
                                                              if (states.contains(
                                                                  WidgetState
                                                                      .disabled)) {
                                                                return AppStyle
                                                                    .disableBlueColorMain;
                                                              }
                                                              if (states.contains(
                                                                  WidgetState
                                                                      .pressed)) {
                                                                return AppStyle
                                                                    .activeBlueColorMain;
                                                              }
                                                              if (states.contains(
                                                                  WidgetState
                                                                      .hovered)) {
                                                                return AppStyle
                                                                    .hoverBlueColorMain;
                                                              }
                                                              return AppStyle
                                                                  .blueColorAdditional4AABDB;
                                                            }),
                                                            minimumSize:
                                                                WidgetStateProperty.all(
                                                              Size(screenWidth * 1,
                                                                  40),
                                                            ),
                                                            shape:
                                                                WidgetStateProperty.all(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(30),
                                                              ),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'Редактировать',
                                                            style: TextStyle(
                                                              color: AppStyle
                                                                  .whiteColorMain,
                                                              fontSize: AppStyle
                                                                  .fontSizeMedium_16,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                          ),
                                                        )
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: null,
                                        );
                                      });

                                  /*await ref.read(updateReferenceStatusControllerProvider.notifier).updateStatus(
                                applicationId: student.id,
                                statusId: 2
                            );*/
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Center(child: Text('Ошибка: $error')),
                loading: () => const Center(child: CircularProgressIndicator())),
          ),
        ],
      ),
    );

  }
}