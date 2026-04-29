import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_fluorography/notifications/notification_service.dart';

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
          toolbarHeight: 80,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5F7FA),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    'assets/images/serch_icon.svg',
                    width: 20,
                    height: 20,
                    color: const Color(0xff98BFF3),
                  ),
                ),
                hintText: 'Поиск',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff26292B),
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Text('Здесь будут уведомления'),
                ElevatedButton(
                    onPressed: () {
                      NotificationService().showNotification(
                        title: 'Заголовок',
                        body:  'Тело сообщения',
                      );
                    },
                    child: const Text('Отправить уведомление')
                )
              ]
            )
        )
      )
    );
  }

}
