// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sky_journal/global_widgets/my_card.dart';
import 'package:sky_journal/module/wallet_module/components/popup_walltet_menu.dart';
import 'package:sky_journal/theme/color_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../database/firestore.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  // PageController
  final PageController _controller = PageController();

  final FirestoreDatabase database = FirestoreDatabase();

  List<QueryDocumentSnapshot> userCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Surface,
      body: SafeArea(
        child: Column(
          children: [
            //app bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'My ',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                      Text(
                        'Cards',
                        style: TextStyle(fontSize: 28, color: textColor),
                      ),
                    ],
                  ),

                  //add card button
                  WalletPopUpMenu(),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),

            //cards
            SizedBox(
              height: 230.0,
              child: StreamBuilder(
                stream: database.getCardStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final cards = snapshot.data!.docs;

                  User? currentUser = FirebaseAuth.instance.currentUser;

                  List<Widget> cardWidgets = [];

                  if (currentUser != null) {
                    for (var card in cards) {
                      String userEmailAddress = card['UserEmail'];
                      String sex = card['Sex'];
                      String weight = card['Weight'];
                      String height = card['Height'];
                      String hairColor = card['Hair'];
                      String eyeColor = card['Eyes'];
                      String dateOfBirth = card['DateOfBirth'];
                      String dateOfIssue = card['DateOfIssue'];
                      String certificationNumber = card['CertificateNumber'];
                      String dateOfExpiry = card['DateOfExpiry'];

                      if (userEmailAddress == currentUser.email) {
                        cardWidgets.add(
                          MyCard(
                            name: 'name',
                            country: "country",
                            sex: sex,
                            weight: weight,
                            height: height,
                            hairColor: hairColor,
                            eyeColor: eyeColor,
                            colorCard: Colors.black,
                            dateOfBirthDay: dateOfBirth,
                            dateOfIssue: dateOfIssue,
                            certificationNumber: certificationNumber,
                            dateOfExpiry: dateOfExpiry,
                          ),
                        );
                      }
                    }
                  }

                  if (cardWidgets.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text(
                          'No cards for the current user',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PageView(
                          controller: _controller,
                          scrollDirection: Axis.horizontal,
                          children: cardWidgets,
                        ),
                      ),
                      SizedBox(height: 10),
                      SmoothPageIndicator(
                        controller: _controller,
                        count: cardWidgets.length,
                        effect: WormEffect(),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
