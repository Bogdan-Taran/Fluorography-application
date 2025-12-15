import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';

class SignInScreen extends StatefulWidget{
  static String id = 'login_screen';

  const SignInScreen({Key? key,}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>{
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    var screenSize = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.black54,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[

            // Декорации
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 1,
                  ),
                ),
              ],
            ),

            Stack(
              children: [
                Container(
                  width: 75.0.w,
                  height: 0.43.h,
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
                        height: 0.04.h,
                      ),
                      Center(
                        child: Text(
                          'Авторизация',
                          style: TextStyle(
                            fontSize: AppSizes.fontSizeTitle.sp,
                            color: Color(0xff26292B),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Geologica',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 15.0.h,
                          left: 0,
                          right: 0,
                          bottom: 20.0.h,
                        ),
                        child: Center(
                          child: Text(
                            'Вход происходит через сетевой город',
                            style: TextStyle(
                              fontSize: AppSizes.fontSizeExtraSmall.sp,
                              color: Color(0xff999A9B),
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Geologica',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.02.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                        child: TextField(
                          controller: loginController,
                          cursorColor: Color(0xff72A7EB),
                          cursorHeight: 17,
                          cursorWidth: 1.2,
                          decoration: InputDecoration(
                            enabled: !isLoading,
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
                              fontSize: AppSizes.fontSizeSmall.sp,
                              color: Color(0xff999A9B),
                              fontWeight: FontWeight.w500,
                            ),

                            contentPadding:
                            AppSizes.loginAndPasswordFieldPadding,
                          ),
                          keyboardType: TextInputType.text,
                          enabled: !isLoading,
                          // maxLength: 25,
                          maxLines: 1,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35),
                        child: TextField(
                          controller: passwordController,
                          cursorColor: Color(0xff72A7EB),
                          cursorHeight: 17,
                          cursorWidth: 1.2,
                          decoration: InputDecoration(
                            enabled: !isLoading,
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
                              fontSize: AppSizes.fontSizeSmall.sp,
                              color: Color(0xff999A9B),
                              fontWeight: FontWeight.w500,
                            ),

                            contentPadding:
                            AppSizes.loginAndPasswordFieldPadding,
                          ),
                          keyboardType: TextInputType.text,
                          // maxLength: 25,
                          enabled: !isLoading,
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
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.05,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: WidgetStateProperty.resolveWith<double>(
                                  (Set<WidgetState> states) => 0,
                            ),
                            backgroundColor:
                            WidgetStateProperty.resolveWith<Color>((
                                Set<WidgetState> states,) {
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
                                Set<WidgetState> states,) {
                              if (states.contains(WidgetState.disabled)) {
                                return Color(0xFF888888);
                              }
                              return Color(0xffffffff);
                            }),
                            minimumSize: WidgetStateProperty.all(
                              Size(MediaQuery
                                  .of(context)
                                  .size
                                  .width * 1, 40),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: isLoading ? null : _performLogin,
                          child: isLoading
                              ? LoadingAnimationWidget.halfTriangleDot(
                            color: Colors.white,
                            size: 24,
                          )
                              : Text(
                            'Войти',
                            style: TextStyle(
                              fontSize: AppSizes.fontSizeMedium.sp,
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