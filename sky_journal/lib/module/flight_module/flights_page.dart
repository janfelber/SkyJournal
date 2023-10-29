// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/global_widgets/my_list_tile.dart';
import 'package:sky_journal/components/push_to_new_page.dart';
import 'package:sky_journal/database/firestore.dart';
import 'package:sky_journal/module/flight_module/addflight_page.dart';
import 'package:sky_journal/module/flight_module/components/searchbar_flights.dart';
import 'package:sky_journal/module/flight_module/flight_details_page.dart';
import '../../global_util/getCurrentDate.dart';
import '../../theme/color_theme.dart';

class Flights extends StatefulWidget {
  const Flights({Key? key}) : super(key: key);

  @override
  State<Flights> createState() => _FlightsState();
}

class _FlightsState extends State<Flights> {
  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController _searchController = TextEditingController();

  bool isFocused = false;

  String? nameOfUser;

  @override
  void initState() {
    super.initState();
    getCurrentUserName(); // call this function to initialize nameOfUser
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
        setState(() {
          nameOfUser = userName; //there we rewrite nameOfUser
        });
      } else {
        print('User does not exist in the database');
      }
    } else {
      print('User is currently signed out');
    }
  }

  String calculateLengthOfFlight(String departureTime, String arrivalTime) {
    var format = DateFormat("HH:mm");
    var one = format.parse(departureTime);
    var two = format.parse(arrivalTime);

    var differenceBetweenTimes = two.difference(one);
    var hoursOfFlight = differenceBetweenTimes.inHours;
    var minutesOfFlight = differenceBetweenTimes.inMinutes.remainder(60);

    return '$hoursOfFlight h $minutesOfFlight min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 25, right: 25, top: 25),
          child: Column(
            children: [
              // Greetings Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (nameOfUser !=
                      null) // Podmínka pro zobrazení pouze pokud je nameOfUser k dispozici
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${nameOfUser}!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          getCurrentDate(),
                          style: TextStyle(color: Colors.blue[200]),
                        ),
                      ],
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (contex) {
                              return AddFlightPage();
                            },
                          ),
                        );
                      },
                      child: Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 25,
              ),

              SearchBarFlights(),
              // SearchBar
              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       isSearching = true;
              //     });
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.blue[600],
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     padding: EdgeInsets.all(12),
              //     child: Row(
              //       children: [
              //         Icon(
              //           Icons.search,
              //           color: Colors.white,
              //         ),
              //         SizedBox(
              //           width: 5,
              //         ),
              //         Text(
              //           'Search',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              SizedBox(
                height: 25,
              ),

              // Flight List
              StreamBuilder(
                stream: database.getFlightsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final flights = snapshot.data!.docs;
                  final List<QueryDocumentSnapshot> userFlights = [];

                  // Get current user
                  User? currentUser = FirebaseAuth.instance.currentUser;

                  if (currentUser != null) {
                    // Get flights for the current user
                    for (var flight in flights) {
                      String userEmailAddress = flight['UserEmail'];

                      if (userEmailAddress == currentUser.email) {
                        userFlights.add(flight);
                      }
                    }
                  }

                  if (userFlights.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text('No flights for the current user'),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: userFlights.length,
                      itemBuilder: (context, index) {
                        final flight = userFlights[index];

                        String flightNumber = flight['FlightNumber'];
                        String startDate = flight['StartDate'];
                        String endDate = flight['EndDate'];
                        String startDestination = flight['StartDestination'];
                        String endDestination = flight['EndDestination'];
                        String timeOfTakeOff = flight['TimeOfTakeOff'];
                        String timeOfLanding = flight['TimeOfLanding'];
                        String airline = flight['Airline'];
                        String numOfPassengers = flight['NumberOfPassangers'];
                        String avgSpeed = flight['AvarageSpeed'];

                        return MyListTile(
                            flightNumber: flightNumber,
                            startDate: startDate,
                            endDate: endDate,
                            startDestination: startDestination,
                            endDestination: endDestination,
                            timeOfTakeOff: timeOfTakeOff,
                            timeOfLanding: timeOfLanding,
                            lengthOfFlight: calculateLengthOfFlight(
                                timeOfTakeOff, timeOfLanding),
                            onTap: () {
                              pushToNewPage(
                                  context,
                                  FlightDetailsPage(
                                    flightNumber: flightNumber,
                                    startDate: startDate,
                                    endDate: endDate,
                                    startDestination: startDestination,
                                    endDestination: endDestination,
                                    timeOfTakeOff: timeOfTakeOff,
                                    timeOfLanding: timeOfLanding,
                                    airline: airline,
                                    numbersOfPassengers: numOfPassengers,
                                    avgSpeed: avgSpeed,
                                  ));
                            });
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}