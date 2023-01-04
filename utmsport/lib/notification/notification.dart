import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void sendNotification({String? title, String? body}) async{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'title',
      'body',
      description: 'description',
      importance: Importance.max);

  flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description),
    ),
  );
}