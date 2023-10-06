import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Flights extends StatefulWidget {
  const Flights({Key? key}) : super(key: key);

  @override
  State<Flights> createState() => _FlightsState();
}

String getCurrentDate() {
  DateTime currentDate = DateTime.now();
  String formattedDate = DateFormat.yMMMMd('en_US').format(currentDate);
  return formattedDate;
}

class _FlightsState extends State<Flights> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: [
              //Greetings Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, John!',
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
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () {},
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
              //SearchBar
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
