import 'package:flutter/material.dart';
import 'package:sky_journal/homepage.dart';
import 'package:sky_journal/pages/flights.dart';
import '../login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUser extends StatelessWidget {
  const AuthUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return AuthPage();
            }
          }),
    );
  }
}
