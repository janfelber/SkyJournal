import 'package:flutter/material.dart';

import '../../database/firestore.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  final FirestoreDatabase database = FirestoreDatabase();

  int numberOfFlights = 0;
  String mostVisitedDestination = '';
  String flightTime = '';
  int longestFlight = 0;
  String longestFlightId = '';
  String averageOfFlights = '';

  // Method to get the number of flights
  Future<int> getNumberofFlights() async {
    // Call the method to get the number of flights from the database
    final int numberOfFlights = await database.getNumberOfFlights();
    return numberOfFlights;
  }

  Future<String> getTotalHours() async {
    // Call the method to get the total hours from the database
    final String flightTime = await database.calculateTotalHours();
    return flightTime;
  }

  Future<String> getMostVisitedDestination() async {
    // Call the method to get the most visited destination from the database
    final String mostVisitedDestination =
        await database.getMostVisitedDestination();
    return mostVisitedDestination;
  }

  Future<int> getLongestFlight() async {
    // Call the method to get the longest flight from the database
    final Map<String, dynamic> longestFlight =
        await database.getLongestFlight();
    return longestFlight['length'];
  }

  Future<String> getLongestFlightId() async {
    // Call the method to get the longest flight from the database
    final Map<String, dynamic> longestFlight =
        await database.getLongestFlight();
    return longestFlight['id'];
  }

  Future<String> getAverageOfFlights() async {
    // Call the method to get the average of flights from the database
    final String averageOfFlights = await database.getAverageOfFlights();
    return averageOfFlights;
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
        flightTime = value;
      });
    });

    getMostVisitedDestination().then((value) {
      setState(() {
        mostVisitedDestination = value;
      });
    });

    getLongestFlight().then((value) {
      setState(() {
        longestFlight = value;
      });
    });
    getLongestFlightId().then((value) {
      setState(() {
        longestFlightId = value;
      });
    });

    getAverageOfFlights().then((value) {
      setState(() {
        averageOfFlights = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text('Total of flights: $numberOfFlights'),
              Text('Most visited destination: $mostVisitedDestination'),
              Text('Total hours of flight: $flightTime'),
              Text('Longest flight: $longestFlight hours'),
              Text('Longest flight id: $longestFlightId'),
              Text('Average of flights: $averageOfFlights'),
            ],
          ),
        ),
      ),
    );
  }
}
