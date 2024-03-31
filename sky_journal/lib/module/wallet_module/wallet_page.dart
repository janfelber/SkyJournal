// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/global_widgets/my_card.dart';
import 'package:sky_journal/module/wallet_module/components/popup_walltet_menu.dart';
import 'package:sky_journal/module/wallet_module/doctors%20appoinments/doctor_appointment.dart';
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

  String? nameOfUser;

  String? dateOfBirth;

  void updateStatusToCompleted(String status) {
    database.updateDoctorAppointmentStatus(status, 'Completed');
    loadDoctorAppointments();
  }

  void updateStatusToCanceled(String status) {
    database.updateDoctorAppointmentStatus(status, 'Canceled');
    loadDoctorAppointments();
  }

  final StreamController<List<QueryDocumentSnapshot>> _cardStreamController =
      StreamController<List<QueryDocumentSnapshot>>();
  final StreamController<List<QueryDocumentSnapshot>>
      _appointmentStreamController =
      StreamController<List<QueryDocumentSnapshot>>();

  List<QueryDocumentSnapshot> userCards = [];
  List doctorAppointments = [];

  int _buttonIndex = 0;

  Future getDateOfBirth() async {
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
        String birthDate = userQuery.docs.first.data()['date of birth'];
        setState(() {
          dateOfBirth = birthDate;
        });
      } else {
        print('User does not exist in the database');
      }
    } else {
      print('User is currently signed out');
    }
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
        String firstName = userQuery.docs.first.data()['first name'];
        String lastName = userQuery.docs.first.data()['last name'];
        setState(() {
          nameOfUser = firstName + ' ' + lastName; //there we rewrite nameOfUser
        });
      } else {
        print('User does not exist in the database');
      }
    } else {
      print('User is currently signed out');
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserName();
    getDateOfBirth();
    loadCards();
    loadDoctorAppointments();
  }

  void loadCards() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    var cardStream = await FirebaseFirestore.instance
        .collection('license-card')
        .where('UserEmail', isEqualTo: currentUser?.email)
        .get();
    _cardStreamController.add(cardStream.docs);
  }

  void loadDoctorAppointments() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    var appointmentStream = await FirebaseFirestore.instance
        .collection('doctor-applications')
        .where('UserEmail', isEqualTo: currentUser?.email)
        .get();
    _appointmentStreamController.add(appointmentStream.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Surface,
      body: SingleChildScrollView(
        child: SafeArea(
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
                    WalletPopUpMenu(
                      onAppointmentAdded: () {
                        loadDoctorAppointments();
                      },
                      onLicenseCardAdded: () {
                        loadCards();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),

              //cards
              StreamBuilder<List<QueryDocumentSnapshot>>(
                stream: _cardStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 260,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final cards = snapshot.data!;

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
                      String certificationNumber = card['CertificateNumber'];
                      String dateOfExpiry = card['DateOfExpiry'];
                      String nationality = card['Nationality'];

                      if (userEmailAddress == currentUser.email) {
                        cardWidgets.add(
                          MyCard(
                            name: nameOfUser ?? 'Unknown',
                            country: nationality,
                            sex: sex,
                            weight: weight,
                            height: height,
                            hairColor: hairColor,
                            eyeColor: eyeColor,
                            colorCard: Colors.black,
                            dateOfBirthDay: dateOfBirth ?? 'Unknown',
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
                        child: Container(
                          height: 260,
                          child: Center(
                            child: Text(
                              'No cards for the current user',
                              style: TextStyle(color: textColor),
                            ),
                          ),
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
                      SizedBox(height: 15),
                      SmoothPageIndicator(
                        controller: _controller,
                        count: cardWidgets.length,
                        effect:
                            ExpandingDotsEffect(dotHeight: 15, dotWidth: 15),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  );
                },
              ),

              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.symmetric(horizontal: 17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 0;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                        decoration: BoxDecoration(
                          color:
                              _buttonIndex == 0 ? Primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Upcoming",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 1;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                          color:
                              _buttonIndex == 1 ? Primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Completed",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 2;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                        decoration: BoxDecoration(
                          color:
                              _buttonIndex == 2 ? Primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Canceled",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              StreamBuilder<List<QueryDocumentSnapshot>>(
                stream: _appointmentStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    return Text('No data available');
                  }
                  // Filter the appointments for the current user
                  User? currentUser = FirebaseAuth.instance.currentUser;
                  final userAppointments = snapshot.data!
                      .where((doc) => doc['UserEmail'] == currentUser?.email)
                      .toList();
                  // Build the appointment widgets
                  List<Widget> appointmentWidgets =
                      buildAppointmentWidgets(userAppointments);

                  // Return a column containing all appointment widgets
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: appointmentWidgets,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build appointment widgets based on the status
  List<Widget> buildAppointmentWidgets(
      List<QueryDocumentSnapshot> appointments) {
    List<Widget> appointmentWidgets = [];
    for (var doc in appointments) {
      // Assuming 'doc' is a QueryDocumentSnapshot with the necessary fields
      var appointment = doc.data() as Map; // Cast the data to a Map
      if (_buttonIndex == 0 && appointment['Status'] == 'Upcoming') {
        // Add each DoctorAppointment widget
        appointmentWidgets.add(DoctorAppointment(
          doctorName: appointment['DoctorName'] ?? 'Unknown',
          date: DateFormat('dd-MM-yyyy')
              .format((appointment['Date'] as Timestamp).toDate()),
          time: appointment['Time'] ?? 'No time',
          status: appointment['Status'] ?? 'No status',
          doctorSpeciality: appointment['DoctorSpeciality'] ?? 'No speciality',
          appointmentId: doc.id, // Pass the document ID as appointmentId
          completedAppointment: () => updateStatusToCompleted(doc.id),
          cancelAppointment: () => updateStatusToCanceled(doc.id),
          // Pass a callback function
        ));

        appointmentWidgets.add(SizedBox(height: 10));
      }

      if (_buttonIndex == 1 && appointment['Status'] == 'Completed') {
        appointmentWidgets.add(DoctorAppointment(
          doctorName: appointment['DoctorName'] ?? 'Unknown',
          date: DateFormat('dd-MM-yyyy')
              .format((appointment['Date'] as Timestamp).toDate()),
          time: appointment['Time'] ?? 'No time',
          status: appointment['Status'] ?? 'No status',
          doctorSpeciality: appointment['DoctorSpeciality'] ?? 'No speciality',
          appointmentId: doc.id, // Pass the document ID as appointmentId
          completedAppointment: () => updateStatusToCompleted(doc.id),
          cancelAppointment: () =>
              updateStatusToCanceled(doc.id), // Pass a callback function
        ));

        appointmentWidgets.add(SizedBox(height: 10));
      }

      if (_buttonIndex == 2 && appointment['Status'] == 'Canceled') {
        appointmentWidgets.add(DoctorAppointment(
          doctorName: appointment['DoctorName'] ?? 'Unknown',
          date: DateFormat('dd-MM-yyyy')
              .format((appointment['Date'] as Timestamp).toDate()),
          time: appointment['Time'] ?? 'No time',
          status: appointment['Status'] ?? 'No status',
          doctorSpeciality: appointment['DoctorSpeciality'] ?? 'No speciality',
          appointmentId: doc.id, // Pass the document ID as appointmentId
          completedAppointment: () => updateStatusToCompleted(doc.id),
          cancelAppointment: () =>
              updateStatusToCanceled(doc.id), // Pass a callback function
        ));

        appointmentWidgets.add(SizedBox(height: 10));
      }
    }
    return appointmentWidgets;
  }
}
