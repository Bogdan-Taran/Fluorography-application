import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_fluorography/bloc/internet_connect/interner_connect_cubit.dart';
import 'home_screen.dart';
import 'package:project_fluorography/bloc/authentication/authentication_bloc.dart';

class SignInScreen extends StatefulWidget {
  static String id = 'login_screen';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: Colors.white),
        child: Scaffold(
          backgroundColor: Color(0xFFFFFFFF),
          body: BlocListener<InternetConnectCubit, InternetConnectState>(
            listener: (context, state){
              switch(state.type){
                case InternetTypes.connected:
                  Fluttertoast.showToast(
                    msg: 'Есть интернет-соединение',
                    backgroundColor: const Color(0xff78ef81),
                    fontSize: 16,
                    gravity: ToastGravity.CENTER,
                    textColor: const Color(0xffffffff),
                  );
                case InternetTypes.offline:
                  Fluttertoast.showToast(
                    msg: 'Нет интернета',
                    backgroundColor: const Color(0xffed6969),
                    fontSize: 16,
                    gravity: ToastGravity.CENTER,
                    textColor: const Color(0xffffffff),
                  );
                case InternetTypes.unknown:
                  Fluttertoast.showToast(
                    msg: 'Есть интернет',
                    backgroundColor: const Color(0xff98BFF3),
                    fontSize: 16,
                    gravity: ToastGravity.CENTER,
                    textColor: const Color(0xffffffff),
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
                        width: screenWidth * 1,
                      ),
                    ),
                  ],
                ),

                Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.43,
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
                            height: screenHeight * 0.04,
                            // height: screenHeight * 0.02,
                          ),
                          Center(
                            child: Text(
                              'Авторизация',
                              style: TextStyle(
                                fontSize: AppSizes.fontSizeTitle,
                                // fontSize: screenWidth * AppSizes.fontSizeTitle,
                                color: Color(0xff26292B),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Geologica',
                              ),
                            ),
                          ),
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
                                  fontSize: AppSizes.fontSizeExtraSmall,
                                  color: Color(0xff999A9B),
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Geologica',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35),
                            child: TextField(
                              controller: loginController,
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

                                hintText: 'Логин',
                                hintStyle: TextStyle(
                                  fontSize: AppSizes.fontSizeSmall,
                                  color: Color(0xff999A9B),
                                  fontWeight: FontWeight.w500,
                                ),
                                contentPadding:
                                    AppSizes.loginAndPasswordFieldPadding,
                              ),

                              keyboardType: TextInputType.text,
                              enabled: true,
                              maxLines: 1,
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                            // height: screenHeight * 0.1,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35),
                            child: TextField(
                              controller: passwordController,
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
                                  fontSize: AppSizes.fontSizeSmall,
                                  color: Color(0xff999A9B),
                                  fontWeight: FontWeight.w500,
                                ),

                                contentPadding:
                                    AppSizes.loginAndPasswordFieldPadding,
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
                          SizedBox(height: screenHeight * 0.02),
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
                                  final errorMessage = state as AuthenticationFailureState;
                                  Fluttertoast.showToast(
                                      msg: errorMessage.errorMessage,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                              }
                            },
                            builder: (context, state) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 35),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<AuthenticationBloc>().add(SignInUserEvent(
                                      loginController.text.trim(),
                                      passwordController.text.trim(),
                                    ));

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
                                          if (states.contains(
                                            WidgetState.disabled,
                                          )) {
                                            return Color(0xffD5D6D7);
                                          }
                                          if (states.contains(
                                            WidgetState.pressed,
                                          )) {
                                            return Color(0xFF72A7EB);
                                          }
                                          if (states.contains(
                                            WidgetState.hovered,
                                          )) {
                                            return Color(0xFFBADEFF);
                                          }
                                          return Color(0xff98BFF3);
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
                                      Size(screenWidth * 1, 40),
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: state is AuthenticationLoadingState
                                      ? LoadingAnimationWidget.halfTriangleDot(
                                          color: Colors.white,
                                          size: 24,
                                        )
                                      : Text(
                                          'Войти',
                                          style: TextStyle(
                                            fontSize: AppSizes.fontSizeMedium,
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
