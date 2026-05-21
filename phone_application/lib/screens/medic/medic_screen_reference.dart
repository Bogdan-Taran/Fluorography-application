import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_fluorography/styles.dart';

class MedicScreenReference extends ConsumerWidget {
  const MedicScreenReference({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
      },
      child: ColorfulSafeArea(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: AppStyle.whiteColorMain,
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
