// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SearchBarFlights extends StatefulWidget {
  const SearchBarFlights({super.key});

  @override
  State<SearchBarFlights> createState() => _SearchBarFlightsState();
}

class _SearchBarFlightsState extends State<SearchBarFlights> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).requestFocus(FocusNode());
        });
      },
      child: TextField(
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
    );
  }
}
