// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sky_journal/components/push_to_new_page.dart';
import 'package:sky_journal/module/settings_module/settings_options/about.dart';
import 'package:sky_journal/module/settings_module/settings_options/appearance.dart';
import 'package:sky_journal/module/settings_module/settings_options/privacy.dart';
import 'package:sky_journal/theme/color_theme.dart';

import 'components/icon_style.dart';
import 'components/settings_group.dart';
import 'components/settings_items.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final user = FirebaseAuth.instance.currentUser!;

  String? nameOfUser;
  String? surnameOfUser;

  @override
  void initState() {
    super.initState();
    getCurrentUserName();
  }

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
        String userSurname = userQuery.docs.first.data()['last name'];
        setState(() {
          nameOfUser = userName;
          surnameOfUser = userSurname;
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
      backgroundColor: Surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  children: [
                    Row(children: [
                      Text('Settings',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    ]),
                    SizedBox(height: 20),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          if (nameOfUser != null && surnameOfUser != null)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${nameOfUser}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${surnameOfUser}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //settings privacy

                    SettingsGroup(
                      items: [
                        SettingsItem(
                          title: 'Appearance',
                          titleStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          subtitle: 'Change the apparence',
                          subtitleStyle: TextStyle(color: Colors.white),
                          onTap: () {
                            pushToNewPage(context, AppareancePage());
                          },
                          icons: CupertinoIcons.pencil_outline,
                          iconStyle: IconStyle(
                            iconsColor: Colors.white,
                            withBackground: true,
                            backgroundColor: Colors.blue,
                            borderRadius: 10,
                          ),
                        ),
                        SettingsItem(
                          title: 'Privacy',
                          titleStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          subtitle: 'Manage your privacy settings',
                          subtitleStyle: TextStyle(color: Colors.white),
                          onTap: () {
                            pushToNewPage(context, PrivacyPage());
                          },
                          icons: Icons.fingerprint,
                          iconStyle: IconStyle(
                            iconsColor: Colors.white,
                            withBackground: true,
                            backgroundColor: Colors.red,
                            borderRadius: 10,
                          ),
                        )
                      ],
                    ),
                    SettingsGroup(
                      items: [
                        SettingsItem(
                          title: 'About',
                          titleStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          subtitle: 'Learn more about Sky Journal',
                          subtitleStyle: TextStyle(color: Colors.white),
                          onTap: () {
                            pushToNewPage(context, AboutApp());
                          },
                          icons: Icons.info_rounded,
                          iconStyle: IconStyle(
                            iconsColor: Colors.white,
                            withBackground: true,
                            backgroundColor: Colors.purple,
                            borderRadius: 10,
                          ),
                        )
                      ],
                    ),
                    SettingsGroup(
                      items: [
                        SettingsItem(
                          title: 'Send Feedback',
                          titleStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          subtitle: 'Send us your feedback',
                          subtitleStyle: TextStyle(color: Colors.white),
                          onTap: () {},
                          icons: Icons.feedback_rounded,
                          iconStyle: IconStyle(
                            iconsColor: Colors.white,
                            withBackground: true,
                            backgroundColor: Colors.orange,
                            borderRadius: 10,
                          ),
                        )
                      ],
                    ),
                    SettingsGroup(
                      settingsGroupTitle: 'Account',
                      settingsGroupTitleStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                      items: [
                        SettingsItem(
                          title: 'Sign Out',
                          titleStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          subtitle: 'Sign out of your account',
                          subtitleStyle: TextStyle(color: Colors.white),
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                          },
                          icons: Icons.exit_to_app_rounded,
                          iconStyle: IconStyle(
                            iconsColor: Colors.white,
                            borderRadius: 10,
                            withBackground: true,
                            backgroundColor: Colors.red,
                          ),
                        ),
                        SettingsItem(
                          title: 'Password',
                          titleStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          subtitle: 'Change your password',
                          subtitleStyle: TextStyle(color: Colors.white),
                          onTap: () {},
                          icons: Icons.password_rounded,
                          iconStyle: IconStyle(
                            iconsColor: Colors.white,
                            borderRadius: 10,
                            withBackground: true,
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// const Text('Settings'),
//           Text('Signed in as: ${user.email!}',
//               style: TextStyle(color: Colors.white)),
//           MaterialButton(
//             onPressed: FirebaseAuth.instance.signOut,
//             color: Colors.red,
//             child: const Text('Sign Out'),
//           ),
//           Text(
//             'App Version: $appVersion',
//             style: TextStyle(color: Colors.grey),
//           ),
