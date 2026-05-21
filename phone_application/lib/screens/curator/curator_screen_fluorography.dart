import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_fluorography/styles.dart';
import '../../services/builders_screen.dart';
import '../../widgets/main_content_accordion_builder.dart';
import 'controller/curator_controller.dart';

class CuratorScreenFluorography extends ConsumerStatefulWidget {
  const CuratorScreenFluorography({super.key});

  @override
  ConsumerState<CuratorScreenFluorography> createState() => _CuratorScreenFluorography();
}

class _CuratorScreenFluorography extends ConsumerState<CuratorScreenFluorography> with AutomaticKeepAliveClientMixin {
  final searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Синхронизация контроллера поиска с состоянием провайдера
    searchController.text = ref.read(curatorSearchQueryProvider);
    searchController.addListener(() {
      if (searchController.text != ref.read(curatorSearchQueryProvider)) {
        ref.read(curatorSearchQueryProvider.notifier).state = searchController.text;
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BuildersScreen _buildersScreen = BuildersScreen();
    final filteredGroupsAsync = ref.watch(filteredCuratorGroupsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
      },
      child: ColorfulSafeArea(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 80.h,
            title: Padding(
              padding: REdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: searchController,
                cursorColor: const Color(0xff72A7EB),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  prefixIcon: Padding(
                    padding: REdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/images/serch_icon.svg',
                      width: 20.w,
                      height: 20.h,
                      color: const Color(0xff98BFF3),
                    ),
                  ),
                  suffixIcon: ref.watch(curatorSearchQueryProvider).isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            ref.read(curatorSearchQueryProvider.notifier).state = '';
                          },
                          icon: Icon(
                            Icons.close,
                            color: const Color(0xff98BFF3),
                            size: 20.r,
                          ),
                        )
                      : null,
                  hintText: 'Поиск',
                  hintStyle: TextStyle(
                    fontSize: AppStyle.fontSizeMedium_16,
                    color: const Color(0xff26292B),
                    fontWeight: FontWeight.w400,
                  ),
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
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: REdgeInsets.symmetric(vertical: 18, horizontal: 8),
                  child: filteredGroupsAsync.when(
                    data: (groups) {
                      if (groups.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50.h),
                            child: Text(
                              'Ничего не нашлось по вашему запросу',
                              style: TextStyle(fontSize: AppStyle.fontSizeMedium_16),
                            ),
                          ),
                        );
                      }
                      return CuratorConstructorAccordionBuildWidget(groups: groups);
                    },
                    loading: () => Center(child: _buildersScreen.buildLoading()),
                    error: (err, stack) => Center(child: Text('Ошибка: $err')),
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
