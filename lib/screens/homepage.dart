import 'package:flutter/material.dart';

import '../services/notification_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

      final NotificationServices _notification = NotificationServices();

  @override
  void initState() {
    super.initState();

    // for notification
    // _notification.isTokenRefresh();
    _notification.requestNotificationPermission();
    _notification.firebaseInit(context);
    _notification.getDeviceToken().then(
      (token) => debugPrint("Token is: $token"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("data!!"),
      ),
    );
  }
}