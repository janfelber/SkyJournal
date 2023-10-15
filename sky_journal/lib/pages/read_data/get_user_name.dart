import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';

class GetUserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Získanie aktuálneho používateľa z Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;

    // Overenie, či je používateľ prihlásený
    if (user != null) {
      // Získanie ID aktuálneho používateľa
      String userId = user.uid;
      print(userId);
    }

    return Scaffold();
  }
}
