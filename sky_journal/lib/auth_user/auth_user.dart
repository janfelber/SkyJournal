import 'package:flutter/material.dart';
import 'package:sky_journal/homepage.dart';
import 'package:sky_journal/auth_user/auth_page.dart';
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
              return const HomePage();
            } else {
              return const AuthPage();
            }
          }),
    );
  }
}
