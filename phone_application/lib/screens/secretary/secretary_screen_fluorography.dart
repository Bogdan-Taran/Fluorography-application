import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_fluorography/styles.dart';


// Флюорография секретерь
class SecretaryScreenFluorography extends ConsumerStatefulWidget {
  const SecretaryScreenFluorography({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SecretaryScreenFluorography();
}

class _SecretaryScreenFluorography extends ConsumerState {
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
        body: Center(
            child: Padding(
              padding: REdgeInsets.all(15.0),
              child: Text(
                  'У вас нет доступа к этой странице. Вам доступна страница "справки"',
                  style: TextStyle(
                    color: AppStyle.blueColorTextTitle,
                    fontSize: AppStyle.fontSizeExtraLarge,
                    fontWeight: FontWeight.w500
                  ),
                textAlign: TextAlign.center,
              ),
            )
        )
    );
  }
}