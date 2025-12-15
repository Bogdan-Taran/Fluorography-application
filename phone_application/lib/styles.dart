import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';


class AppSizes {
  //Размеры шрифтов
  static const double fontSizeTitle = 24;
  static const double fontSizeLarge = 18;
  static const double fontSizeMedium = 16;
  static const double fontSizeMediumMini = 14;
  static const double fontSizeSmall = 12;
  static const double fontSizeExtraSmall = 10;

  //Paddings
  static const double contentPaddingTextFieldVertical = 40;
  static const double contentPaddingTextFieldHorizontal = 40;

  static const EdgeInsets loginAndPasswordFieldPadding = EdgeInsets.only(
    top: 8,
    right: 20,
    bottom: 8,
    left: 16,
  );
}




class TextStyles{
  TextStyle textStyleTitle(BuildContext context){
    return TextStyle(
      fontSize: AppSizes.fontSizeTitle.sp,
      color: Color(0xff26292B),
      fontWeight: FontWeight.w400,
      fontFamily: 'Geologica',
    );
  }

}