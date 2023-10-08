// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future getCurrentUserId() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String userId = user.uid;
    return userId;
  } else {
    print('User is not logged in');
  }
}

final _startDestinationController = TextEditingController();

Future addFlight() async {
  String userId = await getCurrentUserId() as String;
  await getFlightDetails(
    userId,
    _startDestinationController.text.trim(),
  );

  _startDestinationController.clear();
}

Future getFlightDetails(String userId, String start) async {
  await FirebaseFirestore.instance.collection('flights').add({
    'user Id': userId,
    'start ': start,
  });
}

@override
void dispose() {
  _startDestinationController.dispose();
  dispose();
}

void addFlightRecord(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(18.0),
      ),
    ),
    builder: (BuildContext bc) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.93,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              // top bar of the modal with grey color
              decoration: BoxDecoration(
                color: Color.fromRGBO(30, 30, 32, 100),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(18.0),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Add Flight',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _startDestinationController.clear();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // start destination text field
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Contain of the modal
                  TextField(
                    controller: _startDestinationController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Start Destination',
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),

                  //add flight buttom
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () {
                        addFlight();
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Add Flight',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
