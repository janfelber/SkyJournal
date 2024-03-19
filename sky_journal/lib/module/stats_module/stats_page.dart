// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_adjacent_string_concatenation

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geodesy/geodesy.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../database/firestore.dart';
import '../../theme/color_theme.dart';
import '../flight_module/flight_details_page.dart';

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
  int numberOfNightFlights = 0;
  int numberOfDayFlights = 0;

  List<AirportData> airports = [];

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

  Future<int> getNumberOfNightFlights() async {
    // Call the method to get the number of night flights from the database
    final int numberOfNightFlights = await database.getTotalNightFlights();
    return numberOfNightFlights;
  }

  Future<int> getNumberOfDayFlights() async {
    // Call the method to get the number of day flights from the database
    final int numberOfDayFlights = await database.getTotalDayFlights();
    return numberOfDayFlights;
  }

  @override
  void initState() {
    super.initState();
    // Call the method to get the number of flights and assign it to the local variable
    loadAirportData().then((_) {
      Future.delayed(Duration(seconds: 5), () {
        calculateTotalDistance().then((value) {
          setState(() {
            totalKmFlown = value;
            isLoading = false;
          });
        });
      });
    });

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
        if (value == '') {
          mostVisitedDestination = 'No destination';
        } else {
          mostVisitedDestination = value;
        }
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

    getNumberOfNightFlights().then((value) {
      setState(() {
        numberOfNightFlights = value;
      });
    });

    getNumberOfDayFlights().then((value) {
      setState(() {
        numberOfDayFlights = value;
      });
    });
  }

  Future<void> loadAirportData() async {
    try {
      // load the CSV file from the assets folder
      final String data =
          await rootBundle.loadString('assets/airports_coords.csv');
      // convert the CSV data to a List of Lists
      List<List<dynamic>> csvTable = CsvToListConverter().convert(data);

      // convert the List of Lists to a List of AirportData objects
      airports = csvTable.map((row) {
        if (row.length >= 4) {
          return AirportData(
            ident: row[0].toString(),
            latitude: double.tryParse(row[1].toString()) ?? 0.0,
            longitude: double.tryParse(row[2].toString()) ?? 0.0,
            municipality: row[3].toString(),
          );
        } else {
          // return an empty AirportData object if the row does not contain the expected number of columns
          return AirportData(
              ident: '', municipality: '', latitude: 0.0, longitude: 0.0);
        }
      }).toList();
    } catch (e) {
      print('Error loading airport data: $e');
    }
  }

  Future<List<AirportData>> getAirportDataFromCode(String airportCode) async {
    try {
      AirportData? airport = airports.firstWhere(
        (element) =>
            element.ident.trim().toUpperCase() == airportCode.toUpperCase(),
        orElse: () => AirportData(
            ident: '', municipality: '', latitude: 0.0, longitude: 0.0),
      );

      if (airport != null) {
        return [airport]; // Return a list containing the airport data
      } else {
        print('Airport with code $airportCode not found.');
        return []; // Return an empty list if airport not found
      }
    } catch (e) {
      print('Error with getting airport data: $e');
      return []; // Return an empty list if any error occurs
    }
  }

  Future<double> calculateTotalDistance() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('flights')
        .where('UserEmail', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    double totalDistance = 0;

    for (var doc in snapshot.docs) {
      final startDestination = doc['StartDestination'];
      final endDestination = doc['EndDestination'];

      final startCoordinates = await getAirportDataFromCode(startDestination);
      final endCoordinates = await getAirportDataFromCode(endDestination);

      final distance = Geodesy().distanceBetweenTwoGeoPoints(
        LatLng(startCoordinates[0].latitude, startCoordinates[0].longitude),
        LatLng(endCoordinates[0].latitude, endCoordinates[0].longitude),
      );

      totalDistance += distance;
    }

    double totalDistanceInKm = totalDistance / 1000;
    totalDistanceInKm = double.parse(totalDistanceInKm.toStringAsFixed(0));

    return totalDistanceInKm;
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
                    ? Image(
                        image: AssetImage('lib/icons/trip.gif'),
                        height: 80,
                        width: 80,
                      )
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
                      ),
                SizedBox(height: 10),
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
                SizedBox(height: 8),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                buildListTile(CupertinoIcons.moon_stars_fill, 'Night flights',
                    '$numberOfNightFlights'),
                SizedBox(height: 8),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                buildListTile(
                    Icons.sunny, 'Day flights', '$numberOfDayFlights'),
              ],
            ),
          ),
        ),
      ),
    );
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
