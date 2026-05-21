import 'dart:core';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_fluorography/screens/secretary/secretary_edit_dialog.dart';
import 'package:project_fluorography/services/api_reference/request_reference_controller.dart';
import 'package:project_fluorography/styles.dart';
import 'package:talker/talker.dart';
import '../../widgets/expansion_tile.dart' as expansion_tile;

class MedicScreenReference extends ConsumerStatefulWidget {
  const MedicScreenReference({super.key});

  @override
  ConsumerState<MedicScreenReference> createState() => _MedicScreenReference();
}

class _MedicScreenReference extends ConsumerState<MedicScreenReference> {
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
      },
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
                      cursorColor: AppStyle.activeBlueColorMain,
                      style: TextStyle(
                        fontSize: AppStyle.fontSizeMedium_16,
                        color: AppStyle.blackColorMain,
                        fontFamily: 'Geologica',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppStyle.whiteColorAdditionalF5F7FA,
                        prefixIcon: Padding(
                          padding: REdgeInsets.all(14.0),
                          child: SvgPicture.asset(
                            'assets/icon/search_icon.svg',
                            width: 20.w,
                            height: 20.h,
                            color: AppStyle.blueColorAdditional98BFF3,
                          ),
                        ),
                        hintText: 'Поиск',
                        hintStyle: TextStyle(
                          fontSize: AppStyle.fontSizeMedium_16,
                          color: AppStyle.blackColorAdditional26292B,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Geologica',
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
                                  color: AppStyle.blueColorAdditional98BFF3,
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
                        color: _showOnlyActive ? AppStyle.blueColorAdditional4AABDB : AppStyle.whiteColorAdditionalF5F7FA,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icon/mobile_checkbox.svg',
                            width: 20.w,
                            height: 20.h,
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: Text(
                              'Показывать только группы с активными заявками',
                              style: TextStyle(
                                fontSize: AppStyle.fontSizeMediumMini_14,
                                color: _showOnlyActive ? Colors.white : AppStyle.blackColorAdditional26292B,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Geologica',
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
              _buildBackgroundDecorations(),
              Center(
                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Эта страница вам недоступна',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppStyle.blueColorTextTitle,
                      fontSize: AppStyle.fontSizeMedium_16,
                      fontFamily: 'Geologica',
                      fontWeight: FontWeight.w500,
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

  Widget _buildBackgroundDecorations() {
    return SizedBox(
      width: 1.sw,
      height: 1.sh,
      child: IgnorePointer(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(1, -1),
              child: SvgPicture.asset(
                'assets/images/vectorRight.svg',
                fit: BoxFit.fitWidth,
              ),
            ),
            Align(
              alignment: const Alignment(1, 0.5),
              child: SvgPicture.asset(
                'assets/images/vectorLine.svg',
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
    );
  }
}
