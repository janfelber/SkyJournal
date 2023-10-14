// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sky_journal/components/my_button.dart';
import 'package:sky_journal/components/my_textfield.dart';
import 'package:sky_journal/database/firestore.dart';

class AddFlightPage extends StatefulWidget {
  const AddFlightPage({Key? key}) : super(key: key);

  @override
  State<AddFlightPage> createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController _flightNumberController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController();

  final TextEditingController _endDateController = TextEditingController();

  final TextEditingController _startDestinationController =
      TextEditingController();

  final TextEditingController _endDestinationController =
      TextEditingController();

  final TextEditingController _timeOfTakeOffController =
      TextEditingController();

  final TextEditingController _timeOfLandingController =
      TextEditingController();

  final TextEditingController _airlineController = TextEditingController();

  void addFlightRecord() {
    //only add flight record if there is something in the text field
    if (_startDestinationController.text.isNotEmpty &&
        _endDestinationController.text.isNotEmpty &&
        _airlineController.text.isNotEmpty &&
        _startDateController.text.isNotEmpty &&
        _endDateController.text.isNotEmpty &&
        _timeOfTakeOffController.text.isNotEmpty &&
        _timeOfLandingController.text.isNotEmpty) {
      String flightNumber = _flightNumberController.text;
      String startDate = _startDateController.text;
      String endDate = _endDateController.text;
      String startDestination = _startDestinationController.text;
      String endDestination = _endDestinationController.text;
      String timeOfTakeOff = _timeOfTakeOffController.text;
      String timeOfLanding = _timeOfLandingController.text;
      String airline = _airlineController.text;
      database.addFlight(flightNumber, startDate, endDate, startDestination,
          endDestination, timeOfTakeOff, timeOfLanding, airline);
    }

    //clear the text field
    _flightNumberController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _startDestinationController.clear();
    _endDestinationController.clear();
    _timeOfTakeOffController.clear();
    _timeOfLandingController.clear();
    _airlineController.clear();

    //go back to the previous page
    Navigator.pop(context);
  }

  String GenerateFlightNumber() {
    //generate a random flight number start with random letter and then 4 random numbers
    for (int i = 0; i < 1; i++) {
      var random = Random();
      String flightNumber = String.fromCharCode(random.nextInt(26) + 65) +
          random.nextInt(10).toString() +
          random.nextInt(10).toString() +
          random.nextInt(10).toString() +
          random.nextInt(10).toString();
      return _flightNumberController.text = flightNumber;
    }
    return '';
  }

  @override
  void initState() {
    GenerateFlightNumber();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _flightNumberController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _startDestinationController.dispose();
    _endDestinationController.dispose();
    _timeOfTakeOffController.dispose();
    _timeOfLandingController.dispose();
    _airlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextField(
                controller: _flightNumberController,
                hintText: 'Flight Number',
                obscureText: false,
                enabled: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              MyTextField(
                controller: _startDateController,
                hintText: 'Date of Departure',
                obscureText: false,
                enabled: true,
              ),
              SizedBox(
                height: 10.0,
              ),
              MyTextField(
                controller: _endDateController,
                hintText: 'Date of Arrival',
                obscureText: false,
                enabled: true,
              ),
              SizedBox(
                height: 10.0,
              ),
              MyTextField(
                controller: _startDestinationController,
                hintText: 'Start Destination',
                enabled: true,
                obscureText: false,
              ),
              SizedBox(
                height: 10.0,
              ),
              MyTextField(
                controller: _endDestinationController,
                hintText: 'End Destination',
                obscureText: false,
                enabled: true,
              ),
              SizedBox(
                height: 10.0,
              ),
              MyTextField(
                controller: _timeOfTakeOffController,
                hintText: 'Time of Take Off',
                obscureText: false,
                enabled: true,
              ),
              SizedBox(
                height: 10.0,
              ),
              MyTextField(
                controller: _timeOfLandingController,
                hintText: 'Time of Landing',
                obscureText: false,
                enabled: true,
              ),
              SizedBox(
                height: 10.0,
              ),
              MyTextField(
                controller: _airlineController,
                hintText: 'Airline',
                enabled: true,
                obscureText: false,
              ),
              SizedBox(
                height: 20.0,
              ),
              MyButton(text: 'Add Record', onTap: addFlightRecord),
            ],
          ),
        ),
      ),
    );
  }
}
