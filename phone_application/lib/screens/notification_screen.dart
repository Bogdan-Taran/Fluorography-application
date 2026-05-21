import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/notifications/notification_service.dart';
import 'package:project_fluorography/styles.dart';

class NotificationScreen extends ConsumerStatefulWidget{
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreen();
}

class _NotificationScreen extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 80.h,
          title: Padding(
            padding: REdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppStyle.whiteColorAdditionalF5F7FA,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.0.r),
                  child: SvgPicture.asset(
                    'assets/images/serch_icon.svg',
                    width: 20.w,
                    height: 20.h,
                    color: AppStyle.blueColorAdditional98BFF3,
                  ),
                ),
                hintText: 'Поиск',
                hintStyle: TextStyle(
                  fontSize: AppStyle.fontSizeMedium_16,
                  color: AppStyle.blackColorAdditional26292B,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Geologica',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: REdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
        body: Padding(
            padding: REdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Text(
                  'Здесь будут уведомления',
                  style: TextStyle(fontSize: AppStyle.fontSizeMedium_16),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                    onPressed: () {
                      NotificationService().showNotification(
                        title: 'Заголовок',
                        body:  'Тело сообщения',
                      );
                    },
                    child: Text(
                      'Отправить уведомление',
                      style: TextStyle(fontSize: AppStyle.fontSizeMedium_16),
                    )
                )
              ]
            )
        )
      )
    );
  }

}
