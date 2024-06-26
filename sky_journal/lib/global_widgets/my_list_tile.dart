// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_string_interpolations

import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final void Function() onTap;
  final String flightNumber;
  final String startDate;
  final String endDate;
  final String startDestination;
  final String endDestination;
  final String timeOfTakeOff;
  final String timeOfLanding;
  final String lengthOfFlight;

  const MyListTile({
    super.key,
    required this.flightNumber,
    required this.startDate,
    required this.endDate,
    required this.startDestination,
    required this.endDestination,
    required this.timeOfTakeOff,
    required this.timeOfLanding,
    required this.lengthOfFlight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Stack(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    children: [
                      Row(
                        //flight number from database
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$flightNumber'),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        //start date and end date from database
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$startDate'),
                          Text('$endDate'),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        //start destination and end destination from database
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$startDestination'),
                          Text('$endDestination')
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        //time of take off and time of landing from database
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$timeOfTakeOff'),
                          Text('$timeOfLanding'),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Row(
                          children: [
                            //icons to represent the flight
                            Icon(Icons.fiber_manual_record, color: Colors.grey),
                            Text('- - - - - - - - - - '),
                            Icon(Icons.flight_takeoff, color: Colors.grey),
                            Text('- - - - - - - - - - '),
                            Icon(Icons.location_on, color: Colors.grey),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //length of flight from database
                          Text(
                            '$lengthOfFlight',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }
}
