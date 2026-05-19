import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_fluorography/bloc/internet_connect/interner_connect_cubit.dart';
import '../styles.dart';
import 'redirect_screen.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class SignInScreen extends StatefulWidget {
  static String id = 'login_screen';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  bool _validateLogin = false;
  bool _validatePassword = false;

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(LoggingInInitializationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.white),
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),

        body: BlocListener<InternetConnectCubit, InternetConnectState>(
          listener: (context, state) {
            switch (state.type) {
                case InternetTypes.connected:
                Fluttertoast.showToast(
                  msg: 'Есть интернет-соединение',
                  backgroundColor: AppStyle.successGreenColor,
                  fontSize: AppStyle.fontSizeMedium_16,
                  gravity: ToastGravity.CENTER,
                  textColor: AppStyle.whiteColorMain,
                );
              case InternetTypes.offline:
                Fluttertoast.showToast(
                  msg: 'Нет интернета',
                  backgroundColor: AppStyle.errorRedColorMain,
                  fontSize: AppStyle.fontSizeMedium_16,
                  gravity: ToastGravity.CENTER,
                  textColor: AppStyle.whiteColorMain,
                );
              case InternetTypes.unknown:
                Fluttertoast.showToast(
                  msg: 'Есть интернет',
                  backgroundColor: AppStyle.defaultBlueColorMain,
                  fontSize: AppStyle.fontSizeMedium_16,
                  gravity: ToastGravity.CENTER,
                  textColor: AppStyle.whiteColorMain,
                );
            }
          },
          child: Stack(
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
                      width: 1.sw,
                    ),
                  ),
                ],
              ),


              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: REdgeInsets.only(left: 16.0, top: 8.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: Color(0xff98BFF3),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),

              Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: 0.75.sw,
                    height: 0.43.sh,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x26D4EAFF),
                          offset: Offset(-4.w, -4.h),
                          blurRadius: 3.r,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x26D4EAFF),
                          offset: Offset(6.w, -7.h),
                          blurRadius: 3.r,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x26D4EAFF),
                          offset: Offset(0, 7.h),
                          blurRadius: 3.r,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 0.04.sh,
                          // height: screenHeight * 0.02,
                        ),
                        Center(
                          child: Text(
                            'Авторизация',
                            style: TextStyle(
                              fontSize: AppStyle.fontSizeTitle,
                              // fontSize: screenWidth * AppSizes.fontSizeTitle,
                              color: Color(0xff26292B),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Geologica',
                            ),
                          ),
                        ),
                        Padding(
                          padding: REdgeInsets.only(
                            top: 15,
                            left: 0,
                            right: 0,
                            bottom: 20,
                          ),
                          child: Center(
                            child: Text(
                              'Вход происходит через сетевой город',
                              style: TextStyle(
                                fontSize: AppStyle.fontSizeExtraSmall,
                                color: AppStyle.grayColorMain,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Geologica',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 0.02.sh),
                        Padding(
                          padding: REdgeInsets.symmetric(horizontal: 35),
                          child: TextField(
                            controller: loginController,
                            cursorColor: Color(0xff72A7EB),
                            cursorHeight: 17.h,
                            cursorWidth: 1.2.w,
                            decoration: InputDecoration(
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide: BorderSide(
                                  color: Color(0xff98BFF3),
                                  width: 1.0.w,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide: BorderSide(
                                  color: Color(0xff72A7EB),
                                  width: 2.w,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide: BorderSide(
                                  color: AppStyle.errorRedColorMain,
                                  width: 2.w,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide: BorderSide(
                                  color: AppStyle.errorRedColorMain,
                                  width: 2.w,
                                ),
                              ),
                              errorText: _validateLogin ? 'Обязательное поле' : null,


                              hintText: 'Логин',
                              hintStyle: TextStyle(
                                fontSize: AppStyle.fontSizeSmall_12,
                                color: AppStyle.grayColorMain,
                                fontWeight: FontWeight.w500,
                              ),
                              contentPadding:
                                  AppStyle.loginAndPasswordFieldPadding,
                            ),
                            keyboardType: TextInputType.text,
                            enabled: true,
                            maxLines: 1,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (text) => setState(() {
                              _validateLogin = loginController.text.isEmpty;
                            }),

                          ),
                        ),
                        SizedBox(
                          height: 0.01.sh,
                          // height: screenHeight * 0.1,
                        ),
                        Padding(
                          padding: REdgeInsets.symmetric(horizontal: 35),
                          child: TextField(
                            controller: passwordController,
                            cursorColor: Color(0xff72A7EB),
                            cursorHeight: 17.h,
                            cursorWidth: 1.2.w,

                            onChanged: (text) => setState(() {
                              _validatePassword = passwordController.text.isEmpty;
                            }),
                            decoration: InputDecoration(
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide: BorderSide(
                                  color: Color(0xff98BFF3),
                                  width: 1.0.w,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide: BorderSide(
                                  color: Color(0xff72A7EB),
                                  width: 2.w,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide: BorderSide(
                                  color: AppStyle.errorRedColorMain,
                                  width: 2.w,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                                borderSide: BorderSide(
                                  color: AppStyle.errorRedColorMain,
                                  width: 2.w,
                                ),
                              ),
                              errorText: _validatePassword ? 'Обязательное поле' : null,
                              hintText: 'Пароль',
                              hintStyle: TextStyle(
                                fontSize: AppStyle.fontSizeSmall_12,
                                color: AppStyle.grayColorMain,
                                fontWeight: FontWeight.w500,
                              ),

                              contentPadding:
                                  AppStyle.loginAndPasswordFieldPadding,
                            ),
                            keyboardType: TextInputType.text,
                            // maxLength: 25,
                            enabled: true,
                            maxLines: 1,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                          ),
                        ),
                        SizedBox(height: 0.02.sh),
                        BlocConsumer<AuthenticationBloc, AuthenticationState>(
                          listener: (context, state) {
                            switch (state.runtimeType) {
                              case AuthenticationSuccessAfterLoginState:
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return HomeScreen();
                                    },
                                  ),
                                );
                              case AuthenticationFailureState:
                                final errorMessage =
                                    state as AuthenticationFailureState;
                                Fluttertoast.showToast(
                                  msg: errorMessage.errorMessage,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: AppStyle.errorRedColorMain,
                                  textColor: AppStyle.whiteColorMain,
                                  fontSize: AppStyle.fontSizeMedium_16,
                                );
                            }
                          },
                          builder: (context, state) {
                            final _isLoading = state is AuthenticationLoadingState;
                            return Padding(
                              padding: REdgeInsets.symmetric(horizontal: 35),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : () {
                                  setState(() {
                                    _validateLogin = loginController.text.isEmpty;
                                    _validatePassword = passwordController.text.isEmpty;
                                  });
                                  if(!_validateLogin && !_validatePassword){
                                      context.read<AuthenticationBloc>().add(
                                        SignInUserEvent(
                                          loginController.text.trim(),
                                          passwordController.text.trim(),
                                        ),
                                      );
                                  }
                                },
                                style: ButtonStyle(
                                  elevation:
                                      WidgetStateProperty.resolveWith<double>(
                                        (Set<WidgetState> states) => 0,
                                      ),
                                  backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>((
                                      Set<WidgetState> states,
                                      ) {
                                    if (states.contains(WidgetState.disabled)) {
                                      return AppStyle.disableBlueColorMain;
                                    }
                                    if (states.contains(WidgetState.pressed)) {
                                      return AppStyle.activeBlueColorMain;
                                    }
                                    if (states.contains(WidgetState.hovered)) {
                                      return AppStyle.hoverBlueColorMain;
                                    }
                                    return AppStyle.blueColorAdditional4AABDB;
                                  }),
                                  foregroundColor:
                                      WidgetStateProperty.resolveWith<Color>((
                                        Set<WidgetState> states,
                                      ) {
                                        if (states.contains(
                                          WidgetState.disabled,
                                        )) {
                                          return Color(0xFF888888);
                                        }
                                        return Color(0xffffffff);
                                      }),
                                  minimumSize: WidgetStateProperty.all(
                                    Size(1.sw, 40.h),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                                child: state is AuthenticationLoadingState
                                    ? LoadingAnimationWidget.halfTriangleDot(
                                        color: Colors.white,
                                        size: 24.r,
                                      )
                                    : Text(
                                        'Войти',
                                        style: TextStyle(
                                          fontSize: AppStyle.fontSizeMedium_16,
                                          // fontSize: screenWidth * AppSizes.fontSizeMedium,
                                          color: Color(0xffffffff),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Geologica',
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
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
}


