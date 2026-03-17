import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sizer/sizer.dart';


class AppStyle {
  //Размеры шрифтов
  static const double fontSizeTitle =       24;
  static const double fontSizeLarge =       18;
  static const double fontSizeMedium =      16;
  static const double fontSizeMediumMini =  14;
  static const double fontSizeSmall =       12;
  static const double fontSizeExtraSmall =  10;

  //Цвета
  static const Color blackColorMain =       Color(0xff26292B);
  static const Color grayColorMain =        Color(0xff999A9B);
  static const Color whiteColorMain =       Color(0xffffffff);
  static const Color blueColorAdditional =  Color(0xff4AABDB);
  static const Color blueColorBorder =      Color(0xff0188FD);
  static const Color defaultBlueColorMain = Color(0xff98BFF3);
  static const Color activeBlueColorMain =  Color(0xff72A7EB);
  static const Color blueColorTextTitle  =  Color(0xff0088CC);
  static const Color hoverBlueColorMain =   Color(0xffBADEFF);
  static const Color collapsedBlueColor =   Color(0xffD4EAFF);
  static const Color disableBlueColorMain = Color(0xffD5D6D7);
  static const Color errorRedColorMain =    Color(0xffD04848);
  static const Color redColorTag =          Color(0xffee2023);
  static const Color successGreenColor =    Color(0xff78ef81);

  //Paddings
  static const double contentPaddingTextFieldVertical = 40;
  static const double contentPaddingTextFieldHorizontal = 40;
  static const EdgeInsetsGeometry contentPaddingDropdownItemLeft = EdgeInsetsGeometry.symmetric(vertical: 4, horizontal: 16);
  static const EdgeInsetsGeometry outsideInputPaddingHorizontal = EdgeInsetsGeometry.symmetric(horizontal: 32);
  static const EdgeInsetsGeometry contentPaddingTextFieldSymmetric = EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16);
  static const EdgeInsets loginAndPasswordFieldPadding = EdgeInsets.only(
    top: 8,
    right: 20,
    bottom: 8,
    left: 16,
  );

  Color testStyle(){
    return grayColorMain;
  }

  //Borders
  static final BorderRadius inputBorderRadius = BorderRadius.circular(30.0);

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