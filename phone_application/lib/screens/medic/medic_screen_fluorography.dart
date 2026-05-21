import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_fluorography/styles.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:project_fluorography/widgets/main_content_accordion_builder.dart';
import 'package:project_fluorography/services/builders_screen.dart';
import 'controller/medic_controller.dart';
import '../../main.dart';

class MedicScreenFluorography extends ConsumerStatefulWidget {
  final VoidCallback? onNotificationPressed;
  const MedicScreenFluorography({super.key, this.onNotificationPressed});

  @override
  ConsumerState<MedicScreenFluorography> createState() => _MedicScreenFluorographyState();
}

class _MedicScreenFluorographyState extends ConsumerState<MedicScreenFluorography> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // синхронизация контроллера поиска с провайдером Riverpod
    searchController.addListener(() {
      ref.read(medicSearchQueryProvider.notifier).state = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCommunityAsync = ref.watch(filteredMedicCommunityProvider);
    final buildersScreen = BuildersScreen();
    final appBarHeight = 80.h;

    return WillPopScope(
      onWillPop: () async => false,
      child: ColorfulSafeArea(
        color: AppStyle.whiteColorMain,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppStyle.whiteColorMain,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppStyle.whiteColorMain,
            elevation: 0,
            toolbarHeight: appBarHeight,
            title: Padding(
              padding: REdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 48.h,
                child: TextField(
                  controller: searchController,
                  cursorColor: AppStyle.activeBlueColorMain,
                  style: TextStyle(
                    fontSize: AppStyle.fontSizeMedium_16,
                    color: AppStyle.blackColorMain,
                    fontFamily: 'Geologica',
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppStyle.whiteColorAdditionalF5F7FA,
                    prefixIcon: Padding(
                      padding: REdgeInsets.all(14.0),
                      child: SvgPicture.asset(
                        'assets/icon/search_icon.svg',
                        width: 20.w,
                        height: 20.h,
                        colorFilter: const ColorFilter.mode(AppStyle.blueColorAdditional98BFF3, BlendMode.srcIn),
                      ),
                    ),
                    hintText: 'Поиск',
                    hintStyle: TextStyle(
                      fontSize: AppStyle.fontSizeMedium_16,
                      color: AppStyle.blackColorAdditional26292B,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Geologica',
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              searchController.clear();
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
                  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              _buildBackgroundDecorations(),
              RefreshIndicator(
                color: AppStyle.blueColorBorder,
                onRefresh: () => ref.refresh(medicControllerProvider.future),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: REdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    child: filteredCommunityAsync.when(
                      data: (community) {
                        if (community.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 100.h),
                              child: Text(
                                'Ничего не нашлось по вашему запросу',
                                style: TextStyle(
                                  fontSize: AppStyle.fontSizeLarge,
                                  fontFamily: 'Geologica',
                                  color: AppStyle.blackColorMain,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }
                        return MedicConstructorAccordionBuildWidget(
                          medicEntireCommunity: community,
                        );
                      },
                      loading: () => Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 100.h),
                          child: buildersScreen.buildLoading(),
                        ),
                      ),
                      error: (err, stack) => Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 100.h),
                          child: Column(
                            children: [
                              Text(
                                'Ошибка при загрузке данных',
                                style: TextStyle(
                                  fontSize: AppStyle.fontSizeMedium_16,
                                  fontFamily: 'Geologica',
                                  color: AppStyle.errorRedColorMain,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () => ref.invalidate(medicControllerProvider),
                                child: const Text('Повторить'),
                              ),
                            ],
                          ),
                        ),
                      ),
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
