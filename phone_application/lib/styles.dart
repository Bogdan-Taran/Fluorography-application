import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  //Размеры шрифтов
  static double get fontSizeTitle => 24.sp;
  static double get fontSizeExtraLarge => 20.sp;
  static double get fontSizeLarge => 18.sp;
  static double get fontSizeMedium_16 => 16.sp;
  static double get fontSizeMediumMini_14 => 14.sp;
  static double get fontSizeSmall_12 => 12.sp;
  static double get fontSizeExtraSmall => 10.sp;

  //Цвета
  static const Color blackColorMain =                                           Color(0xff26292B);
  static const Color grayColorMain =                                            Color(0xff999A9B);
  static const Color whiteColorMain =                                           Color(0xffffffff);
  static const Color blueColorAdditional4AABDB =                                Color(0xff4AABDB);
  static const Color blueColorAdditional98BFF3 =                                Color(0xff98BFF3);
  static const Color whiteColorAdditionalF5F7FA =                               Color(0xffF5F7FA);
  static const Color blackColorAdditional26292B =                               Color(0xff26292B);
  static const Color blueColorBorder =                                          Color(0xff0188FD);
  static const Color defaultBlueColorMain =                                     Color(0xff98BFF3);
  static const Color activeBlueColorMain =                                      Color(0xff72A7EB);
  static const Color blueColorTextTitle  =                                      Color(0xff0088CC);
  static const Color hoverBlueColorMain =                                       Color(0xffBADEFF);
  static const Color collapsedBlueColorD4EAFF =                                 Color(0xffD4EAFF);
  static const Color disableBlueColorMain =                                     Color(0xffD5D6D7);
  static const Color errorRedColorMain =                                        Color(0xffD04848);
  static const Color redColorTag =                                              Color(0xffee2023);
  static const Color yellowColorTag =                                           Color(0xffFDA827);
  static const Color successGreenColor =                                        Color(0xff78ef81);
  static const Color statusReadyGreenColor18CC00=                               Color(0xff18CC00);
  static const Color yellowProcessColor =                                       Color(0xffFDA827);

  //Paddings
  static const double contentPaddingTextFieldVertical =                         40;
  static const double contentPaddingTextFieldHorizontal =                       40;
  static final EdgeInsetsGeometry contentPaddingDropdownItemLeft =              REdgeInsets.symmetric(vertical: 4, horizontal: 16);
  static final EdgeInsetsGeometry outsideInputPaddingHorizontal =               REdgeInsets.symmetric(horizontal: 32);
  static final EdgeInsetsGeometry contentPaddingTextFieldSymmetric =            REdgeInsets.symmetric(vertical: 8, horizontal: 16);
  static final EdgeInsets loginAndPasswordFieldPadding =                        REdgeInsets.only(top: 8, right: 20, bottom: 8, left: 16);

  Color testStyle(){
    return grayColorMain;
  }

  //Borders
  static final BorderRadius inputBorderRadius = BorderRadius.circular(30.0.r);

  //FontWeight
  static final FontWeight inputFontWeight = FontWeight.w400;
}




class TextStyles{
  TextStyle textStyleTitle(BuildContext context){
    return TextStyle(
      fontSize: AppStyle.fontSizeTitle,
      color: Color(0xff26292B),
      fontWeight: FontWeight.w400,
      fontFamily: 'Geologica',
    );
  }

}