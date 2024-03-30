// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_journal/auth_user/auth_user.dart';
import 'package:sky_journal/components/push_to_new_page.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/module/flight_module/components/toast.dart';
import 'package:sky_journal/module/settings_module/components/settings_group.dart';
import 'package:sky_journal/module/settings_module/components/settings_items.dart';

import '../../../theme/color_theme.dart';
import '../components/icon_style.dart';
import 'privacy_policy/privacy_policy.dart';
import 'terms_of_use/terms_of_use.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  void deleteAccount(BuildContext context) {
    // Show a confirmation dialog for reauthentication
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? enteredEmail;
        String? enteredPassword;

        return AlertDialog(
          backgroundColor: PopUp,
          title: Text(
            "Reauthentication Required",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  enteredEmail = value;
                },
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white)),
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  enteredPassword = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Prompt the user to reauthenticate
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null &&
                      enteredEmail != null &&
                      enteredPassword != null) {
                    await user.reauthenticateWithCredential(
                      EmailAuthProvider.credential(
                          email: enteredEmail!, password: enteredPassword!),
                    );
                    // If reauthentication is successful, show confirmation dialog for account deletion
                    Navigator.pop(context);
                    showConfirmationDialog(context);
                  } else {
                    showToast(context,
                        textToast: 'Invalid email or password',
                        colorToast: Colors.red,
                        imagePath: 'lib/icons/doctor-problem.png');
                  }
                } catch (error) {
                  showToast(context,
                      textToast: 'Invalid email or password',
                      colorToast: Colors.red,
                      imagePath: 'lib/icons/doctor-problem.png');
                }
              },
              child:
                  Text("Reauthenticate", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

// Function to show confirmation dialog for account deletion
  void showConfirmationDialog(BuildContext context) {
    // Show a confirmation dialog for account deletion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: PopUp,
          title:
              Text("Confirm Deletion", style: TextStyle(color: Colors.white)),
          content: Text(
              "Are you sure ? Your data will be permanently deleted. This action cannot be undone.",
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Get the current user from Firebase Authentication
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    // Access Firestore database
                    FirebaseFirestore firestore = FirebaseFirestore.instance;

                    // Reference to the collection containing user data
                    CollectionReference userDataCollection =
                        firestore.collection('users');

                    CollectionReference flightDataCollection =
                        firestore.collection('flights');

                    CollectionReference licenseCardsDataCollection =
                        firestore.collection('license-card');

                    CollectionReference doctorAppointmentDataCollection =
                        firestore.collection('doctor-applications');

                    // Query to find documents associated with user's email
                    QuerySnapshot userDataSnapshot = await userDataCollection
                        .where('email', isEqualTo: user.email)
                        .get();

                    QuerySnapshot flightDataSnapshot =
                        await flightDataCollection
                            .where('UserEmail', isEqualTo: user.email)
                            .get();

                    QuerySnapshot licenseCardsDataSnapshot =
                        await licenseCardsDataCollection
                            .where('UserEmail', isEqualTo: user.email)
                            .get();

                    QuerySnapshot doctorAppointmentDataSnapshot =
                        await doctorAppointmentDataCollection
                            .where('UserEmail', isEqualTo: user.email)
                            .get();

                    licenseCardsDataSnapshot.docs.forEach((doc) async {
                      await doc.reference.delete();
                    });

                    doctorAppointmentDataSnapshot.docs.forEach((doc) async {
                      await doc.reference.delete();
                    });

                    flightDataSnapshot.docs.forEach((doc) async {
                      await doc.reference.delete();
                    });

                    userDataSnapshot.docs.forEach((doc) async {
                      await doc.reference.delete();
                    });

                    // Delete the user's account
                    await user.delete();
                    // Account deletion successful
                    print('Account deleted successfully');

                    Navigator.pop(context);

                    pushToNewPage(context, AuthUser());
                  } else {
                    print('User is not signed in.');
                  }
                } catch (error) {
                  print('Failed to delete account: $error');
                }
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Surface,
      appBar: CustomAppBar(title: 'Privacy'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Column(
                children: [
                  SettingsGroup(
                      settingsGroupTitle: 'Privacy and Security',
                      settingsGroupTitleStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      items: [
                        SettingsItem(
                          title: 'Biometric Lock',
                          titleStyle: TextStyle(color: Colors.white),
                          subtitleStyle: TextStyle(color: Colors.white),
                          icons: Icons.fingerprint,
                          iconStyle: IconStyle(
                              iconsColor: Colors.white,
                              withBackground: true,
                              backgroundColor: Colors.red),
                          onTap: () {},
                          trailing: Switch.adaptive(
                            value: false,
                            onChanged: (value) {},
                          ),
                        ),
                        SettingsItem(
                          title: 'Delete Account',
                          titleStyle: TextStyle(color: Colors.white),
                          subtitleStyle: TextStyle(color: Colors.white),
                          icons: CupertinoIcons.delete,
                          iconStyle: IconStyle(
                              iconsColor: Colors.white,
                              withBackground: true,
                              backgroundColor: Colors.red),
                          onTap: () {
                            deleteAccount(context);
                          },
                        ),
                        SettingsItem(
                          title: 'Terms of Use',
                          titleStyle: TextStyle(color: Colors.white),
                          onTap: () {
                            pushToNewPage(context, TermsOfUsePage());
                          },
                        ),
                        SettingsItem(
                          title: 'Privacy Policy',
                          titleStyle: TextStyle(color: Colors.white),
                          onTap: () {
                            pushToNewPage(context, PrivacyPolicyPage());
                          },
                        ),
                      ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
