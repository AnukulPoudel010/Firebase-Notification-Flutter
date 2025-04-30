import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationServices {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  void requestNotificationPermission() async {
    // ask for permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
      providesAppNotificationSettings: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("user granted permission");
    }
    // for iphone
    else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint("user granted provisional permission");
    } else {
      debugPrint("User denied permission");
      AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await _messaging.getToken();
    if (token == null) {
      throw Exception("tooken is null");
    }
    return token;
  }

  // token can expire so listen and send to server
  void isTokenRefresh() async {
    _messaging.onTokenRefresh
        .listen((event) {
          event.toString();
          debugPrint("refresh");
        })
        .onError(
          (err) => debugPrint("error getting token for firebase notification"),
        );
  }
}
