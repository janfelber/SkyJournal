// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/global_widgets/my_list_tile.dart';
import 'package:sky_journal/components/push_to_new_page.dart';
import 'package:sky_journal/database/firestore.dart';
import 'package:sky_journal/module/flight_module/addflight_page.dart';
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

  TextEditingController _searchController = TextEditingController();

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
                          getCurrentDate('MMMM dd, yyyy'),
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

              GestureDetector(
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: isFocused ? Colors.blue : Colors.grey,
                    ),
                    label: Text(
                      'Search Flights',
                      style: TextStyle(
                        color: isFocused ? Colors.grey : Colors.grey,
                      ),
                    ),
                    alignLabelWithHint: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  onTap: () {
                    setState(() {
                      isFocused = true;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      isFocused = false;
                    });
                  },
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(
                height: 25,
              ),

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

                  if (_searchController.text.isNotEmpty) {
                    userFlights.removeWhere((flight) {
                      String flightNumber =
                          flight['FlightNumber'].toString().toLowerCase();
                      String startDestination =
                          flight['StartDestination'].toString().toLowerCase();
                      String endDestination =
                          flight['EndDestination'].toString().toLowerCase();
                      String startDate =
                          flight['StartDate'].toString().toLowerCase();
                      String endDate =
                          flight['EndDate'].toString().toLowerCase();
                      String timeOfTakeOff =
                          flight['TimeOfTakeOff'].toString().toLowerCase();
                      String timeOfLanding =
                          flight['TimeOfLanding'].toString().toLowerCase();
                      String airline =
                          flight['Airline'].toString().toLowerCase();
                      String numOfPassengers =
                          flight['NumberOfPassangers'].toString().toLowerCase();
                      String avgSpeed =
                          flight['AvarageSpeed'].toString().toLowerCase();
                      String searchQuery = _searchController.text.toLowerCase();
                      return !flightNumber.contains(searchQuery) &&
                          !startDestination.contains(searchQuery) &&
                          !endDestination.contains(searchQuery) &&
                          !startDate.contains(searchQuery) &&
                          !endDate.contains(searchQuery) &&
                          !timeOfTakeOff.contains(searchQuery) &&
                          !timeOfLanding.contains(searchQuery) &&
                          !airline.contains(searchQuery) &&
                          !numOfPassengers.contains(searchQuery) &&
                          !avgSpeed.contains(searchQuery);
                    });
                  }

                  if (userFlights.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text(
                          'No flights for the current user',
                          style: TextStyle(color: Colors.white),
                        ),
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
