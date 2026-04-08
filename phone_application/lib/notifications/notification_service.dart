import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async{
    if(_isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await notificationsPlugin.initialize(settings: initSettings);
  }

  NotificationDetails notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notification Channel',
        channelDescription: 'Daily notifications for Flura',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id: id,
      body: body,
      title: title,
      notificationDetails: notificationDetails(),
    );
  }

}