import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background message ${message.messageId}');
}

class FcmServices {
  static final FcmServices _shared = FcmServices._sharedInstance();
  FcmServices._sharedInstance();
  factory FcmServices() => _shared;

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
}
