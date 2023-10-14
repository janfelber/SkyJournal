import 'package:flutter/material.dart';

class FlightDetailsPage extends StatelessWidget {
  final String flightNumber;
  final String startDate;
  final String endDate;
  final String startDestination;
  final String endDestination;
  final String timeOfTakeOff;
  final String timeOfLanding;
  final String airline;

  const FlightDetailsPage(
      {super.key,
      required this.flightNumber,
      required this.startDate,
      required this.endDate,
      required this.startDestination,
      required this.endDestination,
      required this.timeOfTakeOff,
      required this.timeOfLanding,
      required this.airline});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Details'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Start Destination: $startDestination'),
            Text('End Destination: $endDestination'),
            Text('Airline: $airline'),
            Text('Flight Number: $flightNumber'),
            Text('Start Date: $startDate'),
            Text('End Date: $endDate'),
            Text('Time of Take Off: $timeOfTakeOff'),
            Text('Time of Landing: $timeOfLanding'),
          ],
        ),
      ),
    );
  }
}
