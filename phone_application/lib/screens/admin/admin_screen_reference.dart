import 'package:flutter/material.dart';
import 'package:project_fluorography/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminScreenReference extends StatelessWidget {
  const AdminScreenReference({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.whiteColorMain,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80.h,
        title: Padding(
          padding: REdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            enabled: false,
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
          Center(
            child: Padding(
              padding: REdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Этот раздел вам недоступен',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppStyle.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                  color: AppStyle.blueColorTextTitle,
                  fontFamily: 'Geologica',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
