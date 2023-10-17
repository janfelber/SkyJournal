// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sky_journal/components/push_to_new_page.dart';
import 'package:sky_journal/pages/addcard_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../util/my_card.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  // PageController
  final PageController _controller = PageController();

  // list of cards
  List<MyCard> cards = [];

  Future<Map<String, String>> getUserInfo() async {
    Map<String, String> userInfo = {
      'name': '',
      'country': '',
      'surname': '',
    };

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
        Map<String, dynamic> userData = userQuery.docs.first.data();
        String firstName = userData['first name'];
        String lastName = userData['last name'];

        userInfo['name'] = '$firstName $lastName';
        userInfo['country'] = userData['country'];
        print(userInfo);
      } else {
        print('User does not exist in the database');
      }
    } else {
      print('User is currently signed out');
    }
    return userInfo;
  }

  Future<void> addNewCard() async {
    Map<String, String> userInfo = await getUserInfo();

    setState(() {
      cards.add(MyCard(
        name: userInfo['name'] ?? 'New Name',
        country: userInfo['country'] ?? 'New Country',
        sex: 'M',
        weight: '80',
        height: '180',
        hairColor: 'Brown',
        eyeColor: 'Brown',
        expiryMonth: 1,
        expiryYear: 30,
        color: Colors.blue[800],
      ));

      // this will animate to the last page
      _controller.animateToPage(
        cards.length - 1,
        duration: Duration(milliseconds: 150), // time of animation
        curve: Curves.ease, // animation curve
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            //app bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'My ',
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Cards',
                        style: TextStyle(fontSize: 28),
                      ),
                    ],
                  ),

                  //add card button
                  GestureDetector(
                    onTap: () {
                      pushToNewPage(context, AddCard());
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),

            //cards
            SizedBox(
              height: 200,
              child: PageView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                children: [
                  if (cards.isNotEmpty) ...cards,
                  // if cards is empty show this
                  if (cards.isEmpty)
                    Container(
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          'No cards on the wallet yet.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(
              height: 25,
            ),

            // Zobrazí sa len ak sú karty k dispozícii
            if (cards.isNotEmpty)
              SmoothPageIndicator(
                controller: _controller,
                count: cards.length,
              )
          ],
        ),
      ),
    );
  }
}
