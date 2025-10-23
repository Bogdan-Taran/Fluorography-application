import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Map userData = {};
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black54,
        // statusBarBrightness: Brightness.light,
        // statusBarIconBrightness: Brightness.light,
      ),
      child:
      Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'assets/images/vectorTop.svg',
                    semanticsLabel: 'Top SVG Image',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Align(
                  alignment: Alignment(1, -0.8),
                  child: SvgPicture.asset(
                    'assets/images/vectorMidle.svg',
                    semanticsLabel: 'Top SVG Image',
                    fit: BoxFit.fill,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset(
                    'assets/images/vectorBottom.svg',
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width * 1,
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.43,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x26D4EAFF),
                        offset: Offset(-4, -4),
                        blurRadius: 3,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0x26D4EAFF),
                        offset: Offset(6, -7),
                        blurRadius: 3,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0x26D4EAFF),
                        offset: Offset(0, 7),
                        blurRadius: 3,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Center(
                        child: Text(
                          'Авторизация',
                          style: TextStyle(
                            fontSize: ResponsiveSizes.getFontSizeTitle(
                              context,
                              baseSize: AppSizes.fontSizeTitle,
                            ),
                            color: Color(0xff26292B),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Geologica',
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.0001,
                      // ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 15,
                          left: 0,
                          right: 0,
                          bottom: 20,
                        ),
                        child: Center(
                          child: Text(
                            'Вход происходит через сетевой город',
                            style: TextStyle(
                              fontSize: ResponsiveSizes.getfontSizeExtraSmall(
                                context,
                                baseSize: AppSizes.fontSizeExtraSmall,
                              ),
                              color: Color(0xff999A9B),
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Geologica',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35),
                        child: TextField(

                          cursorColor: Color(0xff72A7EB),
                          cursorHeight: 17,
                          cursorWidth: 1.2,
                          decoration: InputDecoration(
                            enabled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xff98BFF3),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xff72A7EB),
                                width: 2,
                              ),
                            ),
                            // labelText: 'Логин',

                            hintText: 'Логин',
                            hintStyle: TextStyle(
                              fontSize: ResponsiveSizes.getfontSizeSmall(
                                context,
                                baseSize: AppSizes.fontSizeSmall,
                              ),
                              color: Color(0xff999A9B),
                              fontWeight: FontWeight.w500,
                            ),
                            // labelStyle: TextStyle(
                            //   fontSize: ResponsiveSizes.getfontSizeSmall(
                            //     context,
                            //     baseSize: AppSizes.fontSizeSmall,
                            //   ),
                            //   color: Color(0xff999A9B),
                            //   fontWeight: FontWeight.w500,
                            // ),
                            contentPadding: AppSizes.loginAndPasswordFieldPadding,
                          ),
                          keyboardType: TextInputType.text,
                          // maxLength: 25,
                          maxLines: 1,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35),
                        child: TextField(
                          cursorColor: Color(0xff72A7EB),
                          cursorHeight: 17,
                          cursorWidth: 1.2,
                          decoration: InputDecoration(
                            enabled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xff98BFF3),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Color(0xff72A7EB),
                                width: 2,
                              ),
                            ),
                            hintText: 'Пароль',
                            hintStyle: TextStyle(
                              fontSize: ResponsiveSizes.getfontSizeSmall(
                                context,
                                baseSize: AppSizes.fontSizeSmall,
                              ),
                              color: Color(0xff999A9B),
                              fontWeight: FontWeight.w500,
                            ),

                            contentPadding: AppSizes.loginAndPasswordFieldPadding,
                          ),
                          keyboardType: TextInputType.text,
                          // maxLength: 25,
                          maxLines: 1,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            elevation: WidgetStateProperty.resolveWith<double>((
                              Set<WidgetState> states,
                            ) {
                              return 0;
                            }),
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>((
                                  Set<WidgetState> states,
                                ) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return Color(0xffD5D6D7);
                                  }
                                  if (states.contains(WidgetState.pressed)) {
                                    return Color(0xFF72A7EB);
                                  }
                                  if (states.contains(WidgetState.hovered)) {
                                    return Color(0xFFBADEFF);
                                  }
                                  return Color(0xff98BFF3);
                                }),
                            foregroundColor:
                                WidgetStateProperty.resolveWith<Color>((
                                  Set<WidgetState> states,
                                ) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return Color(0xFF888888);
                                  }
                                  return Color(0xffffffff);
                                }),
                            minimumSize: WidgetStateProperty.all(
                              Size(MediaQuery.of(context).size.width * 1, 40),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          child: Text(
                            'Войти',
                            style: TextStyle(
                              fontSize: ResponsiveSizes.getFontSizeMedium(
                                context,
                                baseSize: AppSizes.fontSizeMedium,
                              ),
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Geologica',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppSizes {
  //Размеры шрифтов
  static const double fontSizeTitle = 24;
  static const double fontSizeLarge = 18;
  static const double fontSizeMedium = 16;
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

class ResponsiveSizes {
  static const designScreenWidth = 360;

  //Fonts
  static double getFontSizeTitle(
    BuildContext context, {
    double baseSize = 24.0,
  }) {
    return baseSize * (MediaQuery.of(context).size.width / designScreenWidth);
  }

  static double getFontSizeLarge(
    BuildContext context, {
    double baseSize = 16.0,
  }) {
    return baseSize * (MediaQuery.of(context).size.width / designScreenWidth);
  }

  static double getFontSizeMedium(
    BuildContext context, {
    double baseSize = 16.0,
  }) {
    return baseSize * (MediaQuery.of(context).size.width / designScreenWidth);
  }

  static double getfontSizeSmall(
    BuildContext context, {
    double baseSize = 12.0,
  }) {
    return baseSize * (MediaQuery.of(context).size.width / designScreenWidth);
  }

  static double getfontSizeExtraSmall(
    BuildContext context, {
    double baseSize = 10.0,
  }) {
    return baseSize * (MediaQuery.of(context).size.width / designScreenWidth);
  }
}

InputDecoration customTextFieldStyle({
  String? labelText,
  String? errorText,
  bool isFocused = false,
  bool isHovered = false,
  bool isEnabled = true,
}) {
  Color borderColor = Color(0xff98BFF3);
  double borderWidth = 1.5;
  Color labelColor = Color(0xff999A9B);

  if (!isEnabled) {
    borderColor = Color(0xffCCCCCC);
  } else if (isFocused) {
    borderColor = Colors.blue;
    borderWidth = 2.0;
  } else if (isHovered) {
    borderColor = Color(0xFF8DC4FF);
    borderWidth = 2.0;
  }

  if (errorText != null) {
    borderColor = Colors.red;
    borderWidth = 1.5;
  }

  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.red, width: 1.5),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Color(0xffCCCCCC), width: 1.5),
    ),
    labelText: labelText,
    labelStyle: TextStyle(
      fontSize: 12,
      color: labelColor,
      fontWeight: FontWeight.w500,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
    errorText: errorText,
  );
}
