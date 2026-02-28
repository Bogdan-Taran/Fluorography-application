import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_fluorography/bloc/internet_connect/interner_connect_cubit.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../styles.dart';

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key});

  @override
  State<ReferenceScreen> createState() => _ReferenceScreen();
}

class _ReferenceScreen extends State<ReferenceScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final List<String> referenceType = ['Справка 1','Справка 2','Справка 3','Справка 4'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(statusBarColor: Colors.white),
        child: Scaffold(
          backgroundColor: Color(0xFFFFFFFF),
          resizeToAvoidBottomInset: true,
          body: BlocListener<InternetConnectCubit, InternetConnectState>(
            listener: (context, state) {
              switch (state.type) {
                case InternetTypes.connected:
                  Fluttertoast.showToast(
                    msg: 'Есть интернет-соединение',
                    backgroundColor: const Color(0xff78ef81),
                    fontSize: 16,
                    gravity: ToastGravity.CENTER,
                    textColor: const Color(0xffffffff),
                  );
                  break;
                case InternetTypes.offline:
                  Fluttertoast.showToast(
                    msg: 'Нет интернета',
                    backgroundColor: const Color(0xffed6969),
                    fontSize: 16,
                    gravity: ToastGravity.CENTER,
                    textColor: const Color(0xffffffff),
                  );
                  break;
                case InternetTypes.unknown:
                  Fluttertoast.showToast(
                    msg: 'Есть интернет',
                    backgroundColor: const Color(0xff98BFF3),
                    fontSize: 16,
                    gravity: ToastGravity.CENTER,
                    textColor: const Color(0xffffffff),
                  );
                  break;
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
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
                        width: screenWidth * 1,
                      ),
                    ),
                  ],
                ),

                SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 42,
                      ),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BlocProvider(
                                        create: (context) =>
                                            InternetConnectCubit(
                                              connectivity: Connectivity(),
                                            ),
                                        child: SignInScreen(),
                                      ),
                                ),
                              );
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
                                      return AppSizes.disableBlueColorMain;
                                    }
                                    if (states.contains(WidgetState.pressed)) {
                                      return AppSizes.activeBlueColorMain;
                                    }
                                    if (states.contains(WidgetState.hovered)) {
                                      return AppSizes.hoverBlueColorMain;
                                    }
                                    return AppSizes.blueColorAdditional;
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
                                Size(screenWidth * 1, 40),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icon/door_icon.svg',
                                  color: AppSizes.whiteColorMain,
                                  height: 13,
                                  width: 13,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Войти в аккаунт',
                                  style: TextStyle(
                                    fontSize: AppSizes.fontSizeMedium,
                                    // fontSize: screenWidth * AppSizes.fontSizeMedium,
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Geologica',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: AppSizes.outsideInputPaddingHorizontal,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
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
                            child: FormBuilder(
                              key: _formKey,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: [
                                  SizedBox(height: screenHeight * 0.04),
                                  Center(
                                    child: Text(
                                      'Подача заявки',
                                      style: TextStyle(
                                        fontSize: AppSizes.fontSizeTitle,
                                        color: AppSizes.blackColorMain,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Geologica',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.015),
                                  Center(
                                    child: Text(
                                      'Пожалуйста учтите, что вам необходимо\nввести ФИО в точности как в паспорте',
                                      style: TextStyle(
                                        fontSize: AppSizes.fontSizeExtraSmall,
                                        color: AppSizes.grayColorMain,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Geologica',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.03),
                                  FormBuilderTextField(
                                    name:
                                        'firstName', // Unique key for this field
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                    decoration: InputDecoration(
                                      enabled: true,
                                      hintText: 'Имя',
                                      contentPadding: AppSizes
                                          .contentPaddingTextFieldSymmetric,
                                      hintStyle: TextStyle(
                                        fontSize: AppSizes.fontSizeSmall,
                                        color: AppSizes.grayColorMain,
                                        fontWeight: AppSizes.inputFontWeight,
                                        // fontFamily: 'Geologica',
                                      ),

                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.blueColorAdditional,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.activeBlueColorMain,
                                          width: 1.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    enabled: true,
                                    maxLines: 1,
                                    cursorColor: Color(0xff72A7EB),
                                    cursorHeight: 17,
                                    cursorWidth: 1.2,
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                  ),

                                  SizedBox(height: screenHeight * 0.01),
                                  FormBuilderTextField(
                                    name:
                                    'lastName', // Unique key for this field
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                    decoration: InputDecoration(
                                      enabled: true,
                                      hintText: 'Фамилия',
                                      contentPadding: AppSizes
                                          .contentPaddingTextFieldSymmetric,
                                      hintStyle: TextStyle(
                                        fontSize: AppSizes.fontSizeSmall,
                                        color: AppSizes.grayColorMain,
                                        fontWeight: AppSizes.inputFontWeight,
                                        // fontFamily: 'Geologica',
                                      ),

                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.blueColorAdditional,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.activeBlueColorMain,
                                          width: 1.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    enabled: true,
                                    maxLines: 1,
                                    cursorColor: Color(0xff72A7EB),
                                    cursorHeight: 17,
                                    cursorWidth: 1.2,
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                  ),


                                  SizedBox(height: screenHeight * 0.01),
                                  FormBuilderTextField(
                                    name:
                                    'patronymic', // Unique key for this field
                                    decoration: InputDecoration(
                                      enabled: true,
                                      hintText: 'Отчество (необязательно)',
                                      contentPadding: AppSizes
                                          .contentPaddingTextFieldSymmetric,
                                      hintStyle: TextStyle(
                                        fontSize: AppSizes.fontSizeSmall,
                                        color: AppSizes.grayColorMain,
                                        fontWeight: AppSizes.inputFontWeight,
                                        // fontFamily: 'Geologica',
                                      ),

                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.blueColorAdditional,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.activeBlueColorMain,
                                          width: 1.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    enabled: true,
                                    maxLines: 1,
                                    cursorColor: Color(0xff72A7EB),
                                    cursorHeight: 17,
                                    cursorWidth: 1.2,
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                  ),


                                  SizedBox(height: screenHeight * 0.01),
                                  FormBuilderTextField(
                                    name:
                                    'groupNumber', // Unique key for this field
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                    decoration: InputDecoration(
                                      enabled: true,
                                      hintText: 'Номер группы',
                                      contentPadding: AppSizes
                                          .contentPaddingTextFieldSymmetric,
                                      hintStyle: TextStyle(
                                        fontSize: AppSizes.fontSizeSmall,
                                        color: AppSizes.grayColorMain,
                                        fontWeight: AppSizes.inputFontWeight,
                                        // fontFamily: 'Geologica',
                                      ),

                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.blueColorAdditional,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.activeBlueColorMain,
                                          width: 1.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    enabled: true,
                                    maxLines: 1,
                                    cursorColor: Color(0xff72A7EB),
                                    cursorHeight: 17,
                                    cursorWidth: 1.2,
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                  ),

                                  SizedBox(height: screenHeight * 0.01),
                                  FormBuilderTextField(
                                    name:
                                    'phoneNumber', // Unique key for this field
                                    decoration: InputDecoration(
                                      enabled: true,
                                      hintText: 'Номер телефона (необязательно)',
                                      contentPadding: AppSizes
                                          .contentPaddingTextFieldSymmetric,
                                      hintStyle: TextStyle(
                                        fontSize: AppSizes.fontSizeSmall,
                                        color: AppSizes.grayColorMain,
                                        fontWeight: AppSizes.inputFontWeight,
                                        // fontFamily: 'Geologica',
                                      ),

                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.blueColorAdditional,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.activeBlueColorMain,
                                          width: 1.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    enabled: true,
                                    maxLines: 1,
                                    cursorColor: Color(0xff72A7EB),
                                    cursorHeight: 17,
                                    cursorWidth: 1.2,
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                  ),

                                  SizedBox(height: screenHeight * 0.01),
                                  FormBuilderTextField(
                                    name:
                                    'numberOfReferences', // Unique key for this field
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                    decoration: InputDecoration(
                                      enabled: true,
                                      hintText: 'Количество справок',
                                      contentPadding: AppSizes
                                          .contentPaddingTextFieldSymmetric,
                                      hintStyle: TextStyle(
                                        fontSize: AppSizes.fontSizeSmall,
                                        color: AppSizes.grayColorMain,
                                        fontWeight: AppSizes.inputFontWeight,
                                        // fontFamily: 'Geologica',
                                      ),

                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.blueColorAdditional,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.activeBlueColorMain,
                                          width: 1.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    enabled: true,
                                    maxLines: 1,
                                    cursorColor: Color(0xff72A7EB),
                                    cursorHeight: 17,
                                    cursorWidth: 1.2,
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                  ),

                                  SizedBox(height: screenHeight * 0.01),
                                  FormBuilderDropdown<String>(
                                    name: 'referenceType',
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(errorText: 'Выберите вид справки'),
                                    ]),
                                    // initialValue: 'Справка 1',
                                    hint: Text(
                                        'Вид справки',
                                        style: TextStyle(
                                          fontSize: AppSizes.fontSizeSmall,
                                          color: AppSizes.grayColorMain,
                                          fontWeight: AppSizes.inputFontWeight,
                                          // fontFamily: 'Geologica',
                                        ),

                                    ),
                                    icon: SvgPicture.asset(
                                      'assets/images/icon_expand_down.svg',
                                      color: AppSizes.blueColorAdditional,
                                      height: 10,
                                      width: 10,
                                    ),

                                    dropdownColor: AppSizes.whiteColorMain,
                                    decoration: InputDecoration(
                                      enabled: true,
                                      contentPadding: AppSizes
                                          .contentPaddingTextFieldSymmetric,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.blueColorAdditional,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.activeBlueColorMain,
                                          width: 1.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                        AppSizes.inputBorderRadius,
                                        borderSide: BorderSide(
                                          color: AppSizes.errorRedColorMain,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    items: referenceType.map((refT) {
                                      return DropdownMenuItem<String>(
                                        value: refT,
                                        child: Container(
                                          padding: AppSizes.contentPaddingTextFieldSymmetric,
                                          decoration: BoxDecoration(
                                            color: AppSizes.blueColorAdditional,
                                            borderRadius: AppSizes.inputBorderRadius,
                                          ),
                                          child: Text(
                                            refT,
                                            style: TextStyle(
                                              color: AppSizes.blackColorMain,
                                              fontSize: AppSizes.fontSizeMedium,
                                              fontFamily: 'Geologica'
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),


                                  ),


                                ],
                              ),
                            ),
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
