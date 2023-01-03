import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationApi {
//   static final _notifications = FlutterLocalNotificationsPlugin();
//
//   static Future _notificationDetails() async{
//     return NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channel id',
//         'channel name',
//         channelDescription:"description",
//         //'channel description',
//         importance: Importance.max,
//       ), //AndroidNotificationDetails
//       //iOS: IOSNotificationDetails(),
//     );
//   }
//   static Future showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     //String? payload,
// }) async =>
//       _notifications.show(
//         id,
//         title,
//         body,
//         await _notificationDetails(),
//         //payload: payload,
//       );
// }

// -------------------------

// class NotificationServices{
//   // final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   //     FlutterLocalNotificationsPlugin();
//   //
//   // final AndroidInitializationSettings _androidInitializationSettings =
//   //     AndroidInitializationSettings('logo');
//
//   void initialiseNotifications() async{
//     InitializationSettings initializationSettings = InitializationSettings(
//       android: _androidInitializationSettings,
//     );
//
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   void sendNotification(String title, String body) async{
//     AndroidNotificationDetails androidNotificationDetails =
//         const AndroidNotificationDetails(
//       'channelId',
//       'channelNamee',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//
//     _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//     );
//   }
// }

// -------------------------

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