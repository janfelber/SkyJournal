import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_journal/auth_user/auth_user.dart';

import 'global_util/notifi_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

Future<String?> getStoredPin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("pin_code");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthUser(),
    );
  }
}
