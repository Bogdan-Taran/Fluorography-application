import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../styles.dart';

class ShowExitDialog extends StatelessWidget{
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;
  const ShowExitDialog({
    super.key,
    required this.onYesPressed,
    required this.onNoPressed,});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Подтверждение выхода', style: TextStyle(fontSize: AppStyle.fontSizeLarge)),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Вы уверены что хотите выйти?',
              style: TextStyle(fontSize: AppStyle.fontSizeMediumMini_14),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        // no
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
            WidgetStateProperty.resolveWith<
                Color
            >((Set<WidgetState> states) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return AppStyle.disableBlueColorMain;
              }
              if (states.contains(
                WidgetState.pressed,
              )) {
                return const Color(
                  0xFFE4E4E4,
                );
              }
              if (states.contains(
                WidgetState.hovered,
              )) {
                return AppStyle.hoverBlueColorMain;
              }
              return AppStyle.whiteColorMain;
            }),
            foregroundColor:
            WidgetStateProperty.all(
              AppStyle.whiteColorMain,
            ),
            minimumSize:
            WidgetStateProperty.all(
              Size(
                0.2.sw,
                35.h,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10.r),
              ),
            ),
          ),
          onPressed: onNoPressed,
          child: Text(
            'Отмена',
            style: TextStyle(
              fontSize: AppStyle.fontSizeMedium_16,
              color: AppStyle.defaultBlueColorMain,
              fontWeight: FontWeight.w600,
              fontFamily: 'Geologica',
            ),
          ),
        ),
        //yes
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
            WidgetStateProperty.resolveWith<
                Color
            >((Set<WidgetState> states) {
              if (states.contains(
                WidgetState.disabled,
              )) {
                return AppStyle.disableBlueColorMain;
              }
              if (states.contains(
                WidgetState.pressed,
              )) {
                return AppStyle.activeBlueColorMain;
              }
              if (states.contains(
                WidgetState.hovered,
              )) {
                return AppStyle.hoverBlueColorMain;
              }
              return AppStyle.defaultBlueColorMain;
            }),
            foregroundColor:
            WidgetStateProperty.all(
              AppStyle.whiteColorMain,
            ),
            minimumSize:
            WidgetStateProperty.all(
              Size(
                0.2.sw,
                35.h,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10.r),
              ),
            ),
          ),
          onPressed: onYesPressed,
          child: Text(
            'Да',
            style: TextStyle(
              fontSize: AppStyle.fontSizeMedium_16,
              color: AppStyle.whiteColorMain,
              fontWeight: FontWeight.w600,
              fontFamily: 'Geologica',
            ),
          ),
        ),
      ],
    );
  }
}