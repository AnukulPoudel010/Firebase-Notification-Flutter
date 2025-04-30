import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notification_app/services/notification_services.dart';
import 'screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MaterialApp(home: HomePage());
  }
}
