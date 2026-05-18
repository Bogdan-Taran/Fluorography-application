import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/styles.dart';
import 'package:talker/talker.dart';
import '../../models/get_reference_model/get_reference_model.dart';
import '../../services/api_reference/request_reference_controller.dart';
import '../../widgets/expansion_tile.dart' as expansion_tile;

class CuratorScreenReference extends ConsumerStatefulWidget {
  const CuratorScreenReference({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CuratorScreenReference();
}

class _CuratorScreenReference extends ConsumerState<CuratorScreenReference> {
  final Map<int, bool> _isExpandedTile = {};
  bool _showOnlyActive = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text;
    final groupedData = ref.watch(groupedApplicationsByGroup((
      name: query.length >= 3 ? query : null,
      onlyUnfinished: _showOnlyActive ? true : null,
    )));
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final talker = Talker();

    ref.listen<AsyncValue<void>>(updateReferenceStatusControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Ошибка'),
              content: Text(error.toString()),
            ),
          );
        },
        data: (_) {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text('Успешно'),
              content: Text('Статус успешно изменен'),
            ),
          );
        },
      );
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: ColorfulSafeArea(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: AppStyle.whiteColorMain,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 140.h,
            title: Padding(
              padding: REdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 48.h,
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      onChanged: (value) {
                        setState(() {});
                      },
                      cursorColor: const Color(0xff72A7EB),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                        prefixIcon: Padding(
                          padding: REdgeInsets.all(14.0),
                          child: SvgPicture.asset(
                            'assets/icon/search_icon.svg',
                            width: 20.w,
                            height: 20.h,
                            color: const Color(0xff98BFF3),
                          ),
                        ),
                        hintText: 'Поиск',
                        hintStyle: TextStyle(
                          fontSize: AppStyle.fontSizeMedium_16,
                          color: const Color(0xff26292B),
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: const Color(0xff98BFF3),
                                  size: 24.r,
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                  10.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showOnlyActive = !_showOnlyActive;
                      });
                    },
                    child: Container(
                      height: 48.h,
                      padding: REdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: _showOnlyActive ? AppStyle.blueColorAdditional4AABDB : const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icon/mobile_checkbox.svg',
                            // color: _showOnlyActive ? Colors.white : const Color(0xff98BFF3),
                            width: 20.w,
                            height: 20.h,
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: Text(
                              'Показывать только группы с активными заявками',
                              style: TextStyle(
                                fontSize: AppStyle.fontSizeMediumMini_14,
                                color: _showOnlyActive ? Colors.white : const Color(0xff26292B),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              SizedBox(
                width: 1.sw,
                height: 1.sh,
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
                          width: 1.sw,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SvgPicture.asset(
                          'assets/images/vectorBottom.svg',
                          fit: BoxFit.fitWidth,
                          width: 1.sw,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: REdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    10.verticalSpace,
                    Expanded(
                      child: groupedData.when(
                        data: (result) {
                          final groups = result.groups.keys.toList();
                          
                          if (groups.isEmpty) {
                            return Center(
                              child: Text(
                                result.message ?? 'Нет справок',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppStyle.blueColorTextTitle,
                                  fontSize: AppStyle.fontSizeMedium_16,
                                ),
                              ),
                            );
                          }
                          
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: groups.length,
                            itemBuilder: (context, index) {
                              final groupName = groups[index];
                              final students = result.groups[groupName]!;
                              final bool groupHasActiveReferences = students.any((s) => s.status_id == 1);
                              final bool groupHasDuplicateReferences = students.any((s) => s.status_id == 3);
                              //final bool isAlert = groupHasActiveReferences || groupHasDuplicateReferences;

                              return Padding(
                                padding: REdgeInsets.only(bottom: 10),
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
                                        padding: REdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                        decoration: groupHasActiveReferences
                                            ? BoxDecoration(
                                                color: AppStyle.redColorTag,
                                                borderRadius: BorderRadius.circular(10.r),
                                              )
                                            : groupHasDuplicateReferences
                                                ? BoxDecoration(
                                                    color: AppStyle.yellowColorTag,
                                                    borderRadius: BorderRadius.circular(10.r),
                                                  )
                                                : BoxDecoration(
                                                    color: AppStyle.blueColorAdditional4AABDB,
                                                    borderRadius: BorderRadius.circular(10.r),
                                                  ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${students.length}',
                                                style: TextStyle(
                                                  color: AppStyle.whiteColorMain,
                                                  fontSize: AppStyle.fontSizeSmall_12,
                                                )),
                                            5.horizontalSpace,
                                            SvgPicture.asset(
                                              'assets/images/people_icon.svg',
                                              color: AppStyle.whiteColorMain,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  collapsedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                      side: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1.w)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                      side: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1.w)),
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
                                      padding: REdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: const Color(0x330088cc), width: 1.h))),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.0015),
                                        title: Text(
                                          '${student.firstname} ${student.lastname}',
                                          style: TextStyle(
                                            color: AppStyle.blackColorMain,
                                            fontSize: AppStyle.fontSizeMedium_16,
                                          ),
                                        ),
                                        trailing: (student.status_id == 1 || student.status_id == 3)
                                            ? SvgPicture.asset(
                                                'assets/icon/reference_warn.svg',
                                                width: 20.w,
                                                color: student.status_id == 1 
                                                    ? AppStyle.redColorTag 
                                                    : AppStyle.yellowColorTag,
                                              )
                                            : const SizedBox(),
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
                                                            bottom: BorderSide(color: AppStyle.collapsedBlueColorD4EAFF, width: 1.h),
                                                          ),
                                                          color: const Color(0xffffffff),
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(50.r),
                                                            topRight: Radius.circular(50.r),
                                                          )),
                                                      padding: REdgeInsets.only(bottom: 10, top: 32, left: 32),
                                                      child: Text(
                                                        'История справок',
                                                        style: TextStyle(
                                                          fontSize: AppStyle.fontSizeExtraLarge,
                                                          fontWeight: FontWeight.w500,
                                                          color: AppStyle.blackColorMain,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 20.w,
                                                      top: 20.h,
                                                      child: IconButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        icon: Icon(
                                                          Icons.close,
                                                          color: AppStyle.blueColorAdditional4AABDB,
                                                          size: 24.r,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                content: Container(
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xffFDFDFD),
                                                      borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(50.r),
                                                        bottomRight: Radius.circular(50.r),
                                                      )),
                                                  padding: REdgeInsets.only(left: 32, right: 32, bottom: 32),
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
                                                            style: const TextStyle(color: AppStyle.blueColorTextTitle),
                                                          ),
                                                          subtitle: Text('группа ${student.group}, ${student.phone}',
                                                              style: TextStyle(fontSize: AppStyle.fontSizeSmall_12)),
                                                        ),
                                                        Expanded(
                                                          child: Consumer(
                                                            builder: (context, ref, child) {
                                                              final historyDataAsync = ref.watch(fetchStudentApplications(student.user_id));
                                                              return historyDataAsync.when(
                                                                data: (data) {
                                                                  if (data.isEmpty) {
                                                                    return Text(
                                                                      'У этого студента нет истории заявок',
                                                                      style: TextStyle(
                                                                          color: AppStyle.blackColorMain,
                                                                          fontSize: AppStyle.fontSizeSmall_12),
                                                                    );
                                                                  }
                                                                  return ListView.builder(
                                                                      padding: EdgeInsets.zero,
                                                                      itemCount: data.length,
                                                                      itemBuilder: (context, index) {
                                                                        final item = data[index];
                                                                        return Container(
                                                                          decoration: BoxDecoration(
                                                                              border: Border(
                                                                                  bottom: BorderSide(
                                                                                      color: AppStyle.collapsedBlueColorD4EAFF,
                                                                                      width: 1.h))),
                                                                          child: ListTile(
                                                                            contentPadding: EdgeInsets.zero,
                                                                            title: Text(item.type_id.applicationTypeName,
                                                                                style: TextStyle(
                                                                                    color: AppStyle.blackColorMain,
                                                                                    fontSize: AppStyle.fontSizeMediumMini_14,
                                                                                    fontWeight: FontWeight.w500)),
                                                                            subtitle: Text(item.date,
                                                                                style: TextStyle(
                                                                                    color: AppStyle.blueColorTextTitle,
                                                                                    fontSize: AppStyle.fontSizeSmall_12,
                                                                                    fontWeight: FontWeight.w500)),
                                                                            trailing: Container(
                                                                              padding: REdgeInsets.symmetric(
                                                                                  vertical: 2, horizontal: 10),
                                                                              decoration: BoxDecoration(
                                                                                  color: item.status_id.statusColor,
                                                                                  borderRadius: BorderRadius.circular(10.r)),
                                                                              child: Text(item.status_id.statusName,
                                                                                  style: TextStyle(
                                                                                      color: AppStyle.whiteColorMain,
                                                                                      fontSize: AppStyle.fontSizeSmall_12,
                                                                                      fontWeight: FontWeight.w500)),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                },
                                                                error: (error, stack) => Center(child: Text('Ошибка загрузки: $error')),
                                                                loading: () => Center(
                                                                  child: LoadingAnimationWidget.halfTriangleDot(
                                                                    color: AppStyle.blueColorAdditional4AABDB,
                                                                    size: 50.r,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
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
                        loading: () => Center(
                          child: LoadingAnimationWidget.halfTriangleDot(
                            color: AppStyle.blueColorAdditional4AABDB,
                            size: 50.r,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
