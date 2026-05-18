import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_fluorography/bloc/internet_connect/interner_connect_cubit.dart';
import 'package:project_fluorography/models/post_reference_model/post_reference_model.dart';
import 'package:project_fluorography/screens/sign_in.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:project_fluorography/services/api_reference/dio_and_interceptors/dio_provider.dart';
import 'package:project_fluorography/services/api_reference/request_provider.dart';
import 'package:project_fluorography/services/api_reference/request_reference_controller.dart';
import 'package:project_fluorography/services/api_reference/request_reference_repository.dart';
import 'package:talker/talker.dart';
import '../../services/builders_screen.dart';
import '../../styles.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/api_reference/request_provider.dart';



class ReferenceScreen extends ConsumerStatefulWidget {
  const ReferenceScreen({super.key});

  @override
  ConsumerState<ReferenceScreen> createState() => _ReferenceScreen();
}

class _ReferenceScreen extends ConsumerState<ReferenceScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final Map<int, String> referenceType = {
    1: 'Справка об обучении',
    2: 'Справка для пенсионного фонда',
    3: 'Справка в военный комиссариат'
  };
  bool? agreePersonalData = false;
  bool showErrorCheckbox = false;
  final talker = Talker();

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
/*
Fluttertoast.showToast(
          msg: 'Ошибка: ${next}',
          backgroundColor: AppStyle.errorRedColorMain,
          fontSize: 16,
          gravity: ToastGravity.CENTER,
          textColor: const Color(0xffffffff),
        );
 */

  @override
  Widget build(BuildContext context) {
    BuildersScreen _buildersScreen = BuildersScreen();


    ref.listen(postApplicationControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (error, stackTrace){
          Fluttertoast.showToast(
            msg: error.toString(),
            backgroundColor: AppStyle.errorRedColorMain,
            fontSize: 16,
            gravity: ToastGravity.CENTER,
            textColor: const Color(0xffffffff),
          );
        },
        data: (data){
          if(data == null) return;
            Fluttertoast.showToast(
              msg: data,
              backgroundColor: AppStyle.successGreenColor,
              fontSize: 16,
              gravity: ToastGravity.CENTER,
              textColor: const Color(0xffffffff),
            );
        }
      );
    });


    // final double screenHeight = MediaQuery.of(context).size.height;
    // final double screenWidth = MediaQuery.of(context).size.width;

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
                        width: 1.sw,
                      ),
                    ),
                  ],
                ),

                SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: REdgeInsets.symmetric(
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
                                    if (states.contains(WidgetState.disabled)) {
                                      return Color(0xFF888888);
                                    }
                                    return Color(0xffffffff);
                                  }),
                              minimumSize: WidgetStateProperty.all(
                                Size(1.sw, 40.h),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.r),
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icon/door_icon.svg',
                                  color: AppStyle.whiteColorMain,
                                  height: 13.w,
                                  width: 13.w,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Войти в аккаунт',
                                  style: TextStyle(
                                    fontSize: AppStyle.fontSizeMedium_16,
                                    // fontSize: screenWidth * AppSizes.fontSizeMedium,
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Geologica',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            padding: AppStyle.outsideInputPaddingHorizontal,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.r),
                              ),
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
                            child: FormBuilder(
                              key: _formKey,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: [
                                  SizedBox(height: 25.h),
                                  Center(

                                    child: Text(
                                      'Подача заявки',
                                      style: TextStyle(
                                        fontSize: AppStyle.fontSizeTitle,
                                        color: AppStyle.blackColorMain,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Geologica',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Center(
                                    child: Text(
                                      'Пожалуйста учтите, что вам необходимо\nввести ФИО в точности как в паспорте',
                                      style: TextStyle(
                                        fontSize: AppStyle.fontSizeExtraSmall,
                                        color: AppStyle.grayColorMain,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Geologica',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  FormBuilderTextField(
                                    name:
                                        'firstName', // Unique key for this field
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(errorText: 'Пожалуйста, введите имя'),
                                    ]),
                                    decoration: InputDecoration(
                                      hintText: 'Имя',
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

                                  SizedBox(height: 10.h),
                                  FormBuilderTextField(
                                    name:
                                    'lastName', // Unique key for this field
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(errorText: 'Пожалуйста, введите фамилию'),
                                    ]),
                                    decoration: InputDecoration(
                                      hintText: 'Фамилия',
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


                                  SizedBox(height: 10.h),
                                  FormBuilderTextField(
                                    name:
                                    'patronymic', // Unique key for this field
                                    decoration: InputDecoration(
                                      hintText: 'Отчество (если есть)',
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


                                  SizedBox(height: 10.h),
                                  FormBuilderTextField(
                                    name:
                                    'groupNumber', // Unique key for this field
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(errorText: 'Пожалуйста, введите номер группы'),
                                    ]),
                                    decoration: InputDecoration(
                                      hintText: 'Номер группы',
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

                                  SizedBox(height: 10.h),
                                  FormBuilderTextField(
                                    name:
                                    'phoneNumber', // Unique key for this field
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.phoneNumber(regex: RegExp(r'^\d{11}$'), errorText: 'Неверный формат номера телефона', checkNullOrEmpty: false)
                                    ]),
                                    decoration: InputDecoration(
                                      hintText: 'Номер телефона (необязательно)',
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

                                  SizedBox(height: 10.h),
                                  FormBuilderTextField(
                                    name:
                                    'numberOfReferences', // Unique key for this field
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(errorText: 'Не заполнены обязательные поля. Пожалуйста, введите данные.'),
                                      FormBuilderValidators.notZeroNumber(errorText: 'Количество справок должно быть не меньше 1'),
                                      FormBuilderValidators.max(2, errorText: 'Количество справок не должно превышать 2')
                                    ]),
                                    decoration: InputDecoration(
                                      hintText: 'Количество справок',
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

                                  SizedBox(height: 10.h),
                                  FormBuilderDropdown<String>(
                                    name: 'referenceType',
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(errorText: 'Выберите вид справки'),
                                    ]),
                                    // initialValue: 'Справка 1',
                                    hint: Text(
                                        'Вид справки',
                                        style: TextStyle(
                                          fontSize: AppStyle.fontSizeSmall_12,
                                          color: AppStyle.grayColorMain,
                                          fontWeight: AppStyle.inputFontWeight,
                                          // fontFamily: 'Geologica',
                                        ),

                                    ),
                                    icon: SvgPicture.asset(
                                      'assets/images/icon_expand_down.svg',
                                      color: AppStyle.blueColorAdditional4AABDB,
                                      height: 10.w,
                                      width: 10.w,
                                    ),

                                    dropdownColor: AppStyle.whiteColorMain,
                                    decoration: InputDecoration(
                                      enabled: true,
                                    ),
                                    items: referenceType.entries.map((entry){
                                      return DropdownMenuItem<String>(
                                        value: entry.key.toString(),
                                        child: Container(
                                          width: 1.sw,
                                          padding: AppStyle.contentPaddingDropdownItemLeft,
                                          decoration: BoxDecoration(
                                            color: AppStyle.blueColorAdditional4AABDB,
                                            borderRadius: AppStyle.inputBorderRadius,
                                          ),
                                          child: Text(
                                            entry.value,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppStyle.blackColorMain,
                                              fontSize: AppStyle.fontSizeSmall_12,
                                              fontFamily: 'Geologica'
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),

                                  SizedBox(height: 20.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Я соглашаюсь на обработку\nперсональных данных',
                                        style: TextStyle(
                                          color: showErrorCheckbox ? AppStyle.errorRedColorMain : AppStyle.blueColorAdditional4AABDB,
                                          fontSize: AppStyle.fontSizeMediumMini_14,
                                          height: 1.3
                                        ),
                                      ),

                                      RoundCheckBox(
                                        onTap: (selected) {
                                          setState(() {
                                            agreePersonalData = !agreePersonalData!;
                                          });
                                          if(selected == true){
                                            setState(() {
                                              showErrorCheckbox = false;
                                            });
                                          }
                                        },
                                        checkedWidget: Icon(
                                            Icons.check,
                                            color: AppStyle.whiteColorMain
                                        ),
                                        uncheckedWidget: Icon(
                                            Icons.check,
                                            color: showErrorCheckbox ? AppStyle.errorRedColorMain : AppStyle.blueColorAdditional4AABDB
                                        ),
                                        animationDuration: Duration(
                                          milliseconds: 50
                                        ),
                                        size: 30.r,
                                        border: Border.all(
                                          width: 1,
                                          color: showErrorCheckbox ? AppStyle.errorRedColorMain : AppStyle.blueColorAdditional4AABDB
                                        ),
                                        uncheckedColor: AppStyle.whiteColorMain,
                                        checkedColor:  AppStyle.blueColorAdditional4AABDB,
                                        isChecked: agreePersonalData,
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  SizedBox(
                                    height: 50.h,
                                    child: ElevatedButton(
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
                                            borderRadius: BorderRadius.circular(20.r),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Отправить',
                                        style: TextStyle(
                                          fontSize: AppStyle.fontSizeMedium_16,
                                          // fontSize: screenWidth * AppSizes.fontSizeMedium,
                                          color: Color(0xffffffff),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Geologica',
                                        ),
                                      ),

                                      onPressed: () async{
                                        talker.info('Reference screen: нажата кнопка SUBMIT');
                                        _formKey.currentState?.validate();
                                        if(agreePersonalData != true){
                                          setState(() {
                                            showErrorCheckbox = true;
                                          });
                                          return;
                                        }

                                        if(_formKey.currentState!.saveAndValidate() && agreePersonalData!){
                                          debugPrint(_formKey.currentState?.value.toString());
                                          final formData = _formKey.currentState!.value;
                                          final referenceData = PostReferenceModel(
                                              firstname: formData['firstName'],
                                              lastname: formData['lastName'],
                                              patronymic: formData['patronymic']?.isNotEmpty == true ? formData['patronymic'] : null,
                                              group: formData['groupNumber'],
                                              type_id: int.parse(formData['referenceType']),
                                              phone: formData['phoneNumber']?.isNotEmpty == true ? formData['phoneNumber'] : null,
                                              quantity: int.parse(formData['numberOfReferences']),
                                          );
                                          try{
                                            talker.log('reference_screen: модель: $referenceData');
                                            ref.read(postApplicationControllerProvider.notifier).submitApplication(referenceData);
                                            talker.info('Reference_screen: Запрос отправлен');
                                          }catch(e){
                                            talker.handle('Reference_screen: ошибка в кнопке elevated button: $e');
                                          }
                                        }
                                      },
                                    ),
                                  ),

                                  /*
                                  Consumer(builder: (context, ref, child) {
                                    final createReference = ref.watch(requestReferenceControllerProvider);

                                    ref.listen(requestReferenceControllerProvider, (previous, next){
                                      next.when(
                                          data: (value){
                                            Fluttertoast.showToast(
                                              msg: 'Запрос успешно отправлен',
                                              backgroundColor: AppSizes.successGreenColor,
                                              fontSize: 16,
                                              gravity: ToastGravity.CENTER,
                                              textColor: AppSizes.whiteColorMain,
                                            );
                                          },
                                          error: (error, stack){
                                            Fluttertoast.showToast(
                                              msg: 'Ошибка: $error',
                                              backgroundColor: AppSizes.errorRedColorMain,
                                              fontSize: 16,
                                              gravity: ToastGravity.CENTER,
                                              textColor: AppSizes.whiteColorMain,
                                            );
                                          },
                                          loading: () => _buildersScreen.buildLoading()
                                      );
                                    });
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        createReference.when(
                                            data: (value){
                                              return Text('Успешно');
                                            },
                                            error: (error, stack) => Text('Ошибка: $error'),
                                            loading: () => Text('Загрузка'),
                                        )
                                      ],
                                    );
                                  }),*/

                                  SizedBox(
                                    height: 30.h,
                                  )

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
