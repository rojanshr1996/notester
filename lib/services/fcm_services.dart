import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background message ${message.messageId}');
}

class FcmServices {
  static final FcmServices _shared = FcmServices._sharedInstance();
  FcmServices._sharedInstance();
  factory FcmServices() => _shared;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<String?> getToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      sharedPreferences.setString("fcmToken", fcmToken);
    }
    return fcmToken;
  }

  Future<bool> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
      return true;
    } else {
      log('User declined or has not accepted permission');
      return false;
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   Navigator.pushNamed(
    //     context,
    //     '/message',
    //     arguments: MessageArguments(message, true),
    //   );
    // });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.defaultImportance,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void sendPushMessage(
      {String fcmToken = "", required String messageBody}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString("fcmToken");

    try {
      final body = <String, dynamic>{
        'notification': <String, dynamic>{
          'body': messageBody,
          'title': 'Reminder for you!'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        "to": "$token",
      };
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA76ahsT4:APA91bHS_EnX12zvhT-GZeDFfT0jHEoaElxvVLr_wQ_TTbsEWdo9cRvaYV4UEJ_6EsNIVfpU7T9J9CpBi9_ce2BKunbUnoDEZu5Q3BFWJZC_UgxQxBFyOXVD4ntRHpiCQVysJKgdZ4Q0',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        sharedPreferences.setBool("notificationSent", true);
      }
    } catch (e) {
      rethrow;
    }
  }
}
