import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/screens/secretary/secretary_edit_dialog.dart';
import 'package:project_fluorography/services/api_reference/request_reference_controller.dart';
import 'package:project_fluorography/styles.dart';
import 'package:talker/talker.dart';
import '../../models/get_reference_model/get_reference_model.dart';
import '../../widgets/expansion_tile.dart' as expansion_tile;

class SecretaryScreenReference extends ConsumerStatefulWidget {
  const SecretaryScreenReference({super.key});

  @override
  ConsumerState<SecretaryScreenReference> createState() => _SecretaryScreenReference();
}

class _SecretaryScreenReference extends ConsumerState<SecretaryScreenReference> {
  final Map<int, bool> _isExpandedTile = {};
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showOnlyActive = false;

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
                        fillColor: Color(0xFFF5F7FA),
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
                                padding: EdgeInsets.zero,
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
                        color: _showOnlyActive ? AppStyle.blueColorAdditional4AABDB : Color(0xFFF5F7FA),
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
                padding: REdgeInsets.symmetric(horizontal: 20.w),
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
                      padding: REdgeInsets.only(top: 10),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final groupName = groups[index];
                        final students = result.groups[groupName]!;
                        final bool groupHasActiveReferences = students.any((s) => s.status_id == 1);
                        final bool groupHasDuplicateReferences = students.any((s) => s.status_id == 3);
                        final bool isHighlighted = groupHasActiveReferences || groupHasDuplicateReferences;

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
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(10.r),
                                              border: Border.all(
                                                color: AppStyle.blackColorMain,
                                                width: 1.w,
                                              )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${students.length}',
                                          style: TextStyle(
                                            color: isHighlighted
                                                ? AppStyle.whiteColorMain
                                                : AppStyle.blackColorMain,
                                            fontSize: AppStyle.fontSizeSmall_12,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      5.horizontalSpace,
                                      SvgPicture.asset(
                                        'assets/images/people_icon.svg',
                                        color: isHighlighted
                                            ? AppStyle.whiteColorMain
                                            : AppStyle.blackColorMain,
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
                            children: [
                              Container(
                                width: double.infinity,
                                padding: REdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: const Color(0x330088cc), width: 1.h))),
                                child: Text(
                                  'Чтобы посмотреть историю справок или изменить статус справки, выберите человека из списка.',
                                  style: TextStyle(
                                    color: AppStyle.activeBlueColorMain,
                                    fontSize: AppStyle.fontSizeMediumMini_14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              ...students.map((student) {
                                return Container(
                                  padding: REdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: const Color(0x330088cc), width: 1.h))),
                                  child: ListTile(
                                    contentPadding: REdgeInsets.symmetric(vertical: 2.h),
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
                                          return SecretaryEditDialog(
                                            student: student,
                                            talker: talker,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ],
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
      ),
    );
  }
}
