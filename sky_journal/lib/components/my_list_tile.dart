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

  const MyListTile({
    super.key,
    required this.flightNumber,
    required this.startDate,
    required this.endDate,
    required this.startDestination,
    required this.endDestination,
    required this.timeOfTakeOff,
    required this.timeOfLanding,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$flightNumber'),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
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
                            Icon(Icons.fiber_manual_record, color: Colors.grey),
                            Text('- - - - - - - - - - -'),
                            Icon(Icons.flight_takeoff, color: Colors.grey),
                            Text('- - - - - - - - - - -'),
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
                          Text(
                            '13 h 25 min',
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

//   return Padding(
//     padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
//     child: Container(
//       decoration: BoxDecoration(
//         color: Colors.blue[800], // Farba pozadia lietadlového lístka
//         borderRadius: BorderRadius.circular(10), // Zaoblené rohy
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2), // Tieni farba
//             blurRadius: 5, // Rozostrenie tieni
//             offset: Offset(0, 2), // Posunutie tieni
//           ),
//         ],
//       ),
//       child: ListTile(
//         title: Text(
//           tile,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//           ),
//         ),
//         subtitle: Text(
//           subtile,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//         onTap: onTap,
//       ),
//     ),
//   );
// }
