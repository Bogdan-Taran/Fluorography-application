import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles.dart';

class AppInputDecorations {
  static InputDecorationTheme theme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: AppStyle.inputBorderRadius,
      borderSide: BorderSide(color: AppStyle.blueColorAdditional4AABDB, width: 1.w),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius:
      AppStyle.inputBorderRadius,
      borderSide: BorderSide(
        color: AppStyle.blueColorAdditional4AABDB,
        width: 1.0.w,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius:
      AppStyle.inputBorderRadius,
      borderSide: BorderSide(
        color: AppStyle.activeBlueColorMain,
        width: 1.0.w,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius:
      AppStyle.inputBorderRadius,
      borderSide: BorderSide(
        color: AppStyle.errorRedColorMain,
        width: 1.w,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius:
      AppStyle.inputBorderRadius,
      borderSide: BorderSide(
        color: AppStyle.errorRedColorMain,
        width: 1.w,
      ),
    ),

    contentPadding: AppStyle
        .contentPaddingTextFieldSymmetric,

    //filled: true,
    fillColor: AppStyle.whiteColorMain,
    isDense: true,
    errorMaxLines: 3,

    hintStyle: TextStyle(
      fontSize: AppStyle.fontSizeSmall_12,
      color: AppStyle.grayColorMain,
      fontWeight: AppStyle.inputFontWeight,
      // fontFamily: 'Geologica',
    ),

    errorStyle: const TextStyle(color: AppStyle.errorRedColorMain),

  );
}