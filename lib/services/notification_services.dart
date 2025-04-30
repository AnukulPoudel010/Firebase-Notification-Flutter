import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// show notification
  Future<void> showNotification(RemoteMessage message) async {
    // android notification detail
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
          Random.secure().nextInt(100000).toString(),
          'High importance Notification',
          importance: Importance.max,
        );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          androidNotificationChannel.id,
          androidNotificationChannel.name,
          channelDescription: 'your channel description',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        );

    // iOS notification detail
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          // firebase does use this for ios
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero, (){
      _flutterLocalNotificationsPlugin.show(0, message.notification!.title, message.notification!.body, notificationDetails);
    });
  }

  /// biuld context and message that is sent from firebase
  void initLocalNotifications(
    BuildContext context,
    RemoteMessage message,
  ) async {
    // for android
    var androidInitializationSettings = AndroidInitializationSettings(
      '@mipmap-mdpi/ic_launcher.png',
    );
    // for ios
    // var iosInitializationSettings = DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      // iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      // App in foreground/background
      onDidReceiveNotificationResponse: (payload) {
        debugPrint("message: ${payload.payload}");
        debugPrint("message: ${payload.payload}");
      },
      // App terminated (cold start)
      onDidReceiveBackgroundNotificationResponse: (payload) {},
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
      if (message.notification?.title != null) {
        debugPrint(
          "Notification title: ${message.notification!.title.toString()}",
        );
        debugPrint(
          "Notification text: ${message.notification!.body.toString()}",
        );
        initLocalNotifications(context, message);
        showNotification(message);
      } else {
        debugPrint("the received notification's title is null");
      }
        showNotification(message);
      }
    });
  }

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
    // TODO: understand this more clearly
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
