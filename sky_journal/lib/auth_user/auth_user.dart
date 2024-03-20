import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sky_journal/homepage.dart';
import 'package:sky_journal/auth_user/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUser extends StatefulWidget {
  const AuthUser({Key? key}) : super(key: key);

  @override
  State<AuthUser> createState() => _AuthUserState();
}

class _AuthUserState extends State<AuthUser> {
  @override
  void initState() {
    super.initState();
    getCurrentUserName();
  }

  String? userName;

  Future getCurrentUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String email = user.email!;

      // get user name from firestore by email
      QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore
          .instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        String userName = userQuery.docs.first.data()['first name'];
        setState(() {
          this.userName = userName; //there we rewrite nameOfUser
        });
      } else {
        print('User does not exist in the database');
      }
    } else {
      print('User is currently signed out');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage(
                userName: userName,
              );
            } else {
              return const AuthPage();
            }
          }),
    );
  }
}
