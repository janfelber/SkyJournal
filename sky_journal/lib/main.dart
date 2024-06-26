import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_journal/auth_user/auth_user.dart';
import 'package:sky_journal/module/onboard_module/on_board_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.instance.requestPermission();

  final prefs = await SharedPreferences.getInstance();
  final showLogin = prefs.getBool('showLogin') ?? false;

  runApp(MyApp(showLogin: showLogin));
}

class MyApp extends StatelessWidget {
  final bool showLogin;
  const MyApp({
    Key? key,
    required this.showLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: showLogin ? AuthUser() : OnBoardingPage(),
    );
  }
}
