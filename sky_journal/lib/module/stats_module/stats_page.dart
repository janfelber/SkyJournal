// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../database/firestore.dart';
import '../../theme/color_theme.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  final FirestoreDatabase database = FirestoreDatabase();

  int numberOfFlights = 0;
  String mostVisitedDestination = '';
  int flightTimeHour = 0;
  int flightTimeMinute = 0;
  int longestFlightHour = 0;
  int longestFlightMinute = 0;
  String longestFlightId = '';
  int averageOfFlightsHour = 0;
  int averageOfFlightsMinute = 0;
  double totalKmFlown = 0;

  String cityFrom = 'Nitra';
  String cityTo = 'Vrable';

  bool isLoading = true;
  // Method to get the number of flights
  Future<int> getNumberofFlights() async {
    // Call the method to get the number of flights from the database
    final int numberOfFlights = await database.getNumberOfFlights();
    return numberOfFlights;
  }

  Future<int> getTotalHours() async {
    // Call the method to get the total hours from the database
    final Map<String, dynamic> flightTime =
        await database.calculateTotalHours();
    return flightTime['hours'];
  }

  Future<int> getTotalMinutes() async {
    // Call the method to get the total hours from the database
    final Map<String, dynamic> flightTime =
        await database.calculateTotalHours();
    return flightTime['minutes'];
  }

  Future<String> getMostVisitedDestination() async {
    // Call the method to get the most visited destination from the database
    final String mostVisitedDestination =
        await database.getMostVisitedDestination();
    return mostVisitedDestination;
  }

  Future<int> getLongestFlightHour() async {
    // Call the method to get the longest flight from the database
    final Map<String, dynamic> longestFlight =
        await database.getLongestFlight();
    return longestFlight['hours'];
  }

  Future<int> getLongestFlightMinute() async {
    // Call the method to get the longest flight from the database
    final Map<String, dynamic> longestFlight =
        await database.getLongestFlight();
    return longestFlight['minutes'];
  }

  Future<String> getLongestFlightId() async {
    // Call the method to get the longest flight from the database
    final Map<String, dynamic> longestFlight =
        await database.getLongestFlight();
    return longestFlight['id'];
  }

  Future<int> getAverageOfFlightsHours() async {
    // Call the method to get the average of flights from the database
    final Map<String, dynamic> averageOfFlights =
        await database.getAverageOfFlights();
    return averageOfFlights['hours'];
  }

  Future<int> getAverageOfFlightsMinutes() async {
    // Call the method to get the average of flights from the database
    final Map<String, dynamic> averageOfFlights =
        await database.getAverageOfFlights();
    return averageOfFlights['minutes'];
  }

  Future<double> getTotalKmFlown() async {
    // Call the method to get the total km flown from the database
    final double totalKmFlown = await database.calculateTotalDistance();
    return totalKmFlown;
  }

  @override
  void initState() {
    super.initState();
    // Call the method to get the number of flights and assign it to the local variable
    getNumberofFlights().then((value) {
      setState(() {
        numberOfFlights = value;
      });
    });

    getTotalHours().then((value) {
      setState(() {
        flightTimeHour = value;
      });
    });

    getTotalMinutes().then((value) {
      setState(() {
        flightTimeMinute = value;
      });
    });

    getMostVisitedDestination().then((value) {
      setState(() {
        mostVisitedDestination = value;
      });
    });

    getLongestFlightHour().then((value) {
      setState(() {
        longestFlightHour = value;
      });
    });

    getLongestFlightMinute().then((value) {
      setState(() {
        longestFlightMinute = value;
      });
    });

    getLongestFlightId().then((value) {
      setState(() {
        longestFlightId = value;
      });
    });

    getAverageOfFlightsHours().then((value) {
      setState(() {
        averageOfFlightsHour = value;
      });
    });

    getAverageOfFlightsMinutes().then((value) {
      setState(() {
        averageOfFlightsMinute = value;
      });
    });

    getTotalKmFlown().then((value) {
      setState(() {
        totalKmFlown = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Surface,
        appBar: AppBar(
          title: Text('Flight Journal', style: TextStyle(color: textColor)),
          backgroundColor: Surface,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/airlines/stats_circuit.png',
                    height: 300,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Flight Distance', // Pridaný popis
                          style: GoogleFonts.bebasNeue(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3),
                  isLoading
                      ? CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${totalKmFlown.toStringAsFixed(0)} KM',
                              style: GoogleFonts.bebasNeue(
                                fontSize: 52,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ), // Medzera medzi textom a čiaro
                  SizedBox(height: 25),
                  SizedBox(height: 8),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  buildListTile(
                      Icons.flight, 'Total of flights', '$numberOfFlights'),
                  SizedBox(height: 8),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  buildListTile(
                    Icons.timer,
                    'Total flight time',
                    '${flightTimeHour > 0 || flightTimeMinute >= 60 ? '${flightTimeHour + flightTimeMinute ~/ 60} hours ' : ''}' +
                        '${(flightTimeHour > 0 || flightTimeMinute >= 60) ? flightTimeMinute % 60 : flightTimeMinute} minutes',
                  ),
                  SizedBox(height: 8),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  buildListTile(
                    Icons.location_city,
                    'Most visited',
                    mostVisitedDestination,
                  ),
                  SizedBox(height: 8),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  buildListTile(
                      Icons.av_timer,
                      'Average of flights',
                      '${averageOfFlightsHour > 0 || averageOfFlightsMinute >= 60 ? '${averageOfFlightsHour + averageOfFlightsMinute ~/ 60} hours ' : ''}' +
                          '${(averageOfFlightsHour > 0 || averageOfFlightsMinute >= 60) ? averageOfFlightsMinute % 60 : averageOfFlightsMinute} minutes'),
                  SizedBox(height: 8),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  buildListTile(Icons.flight_class, 'Longest flight id',
                      '$longestFlightId'),

                  SizedBox(height: 8),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  buildListTile(
                      Icons.flight_takeoff,
                      'Longest flight',
                      '${longestFlightHour > 0 || longestFlightMinute >= 60 ? '${longestFlightHour + longestFlightMinute ~/ 60} hours ' : ''}' +
                          '${(longestFlightHour > 0 || longestFlightMinute >= 60) ? longestFlightMinute % 60 : longestFlightMinute} minutes'),
                ],
              ),
            ),
          ),
        ));
  }

  ListTile buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Primary,
        ),
        child: Icon(icon),
      ),
      title: Text(title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          )),
      trailing: Text(subtitle,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          )),
    );
  }
}
