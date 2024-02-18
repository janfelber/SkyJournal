// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/global_widgets/my_button.dart';
import 'package:sky_journal/global_widgets/my_textfield.dart';
import 'package:sky_journal/database/firestore.dart';

import '../../theme/color_theme.dart';

class AddFlightPage extends StatefulWidget {
  const AddFlightPage({Key? key}) : super(key: key);

  @override
  State<AddFlightPage> createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  String numOfPassengers = "0";

  String avgSpeed = "0";

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
    //only add flight record if there is something in the text fields
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
      database.addFlight(
        flightNumber,
        startDate,
        endDate,
        startDestination,
        endDestination,
        timeOfTakeOff,
        timeOfLanding,
        airline,
        numOfPassengers,
        avgSpeed,
      );
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

  String generateRandomNUmberOfPassangers() {
    Random rnd;
    int min = 170;
    int max = 388;
    rnd = new Random();
    int numberOfPassangers = min + rnd.nextInt(max - min);
    numOfPassengers = numberOfPassangers.toString();
    return numOfPassengers;
  }

  String generateRandomAvgSpeed() {
    Random rnd;
    int min = 800;
    int max = 1000;
    rnd = new Random();
    int averageSpeed = min + rnd.nextInt(max - min);
    avgSpeed = averageSpeed.toString();
    return avgSpeed;
  }

  String generateFlightNumber() {
    //generate a random flight number start with random letter and then 4 random numbers
    var random = Random();
    String flightNumber = String.fromCharCode(random.nextInt(26) + 65) +
        random.nextInt(10).toString() +
        random.nextInt(10).toString() +
        random.nextInt(10).toString() +
        random.nextInt(10).toString();
    return _flightNumberController.text = flightNumber;
  }

  String getDateOnRecord() {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('dd MMM yyy').format(currentDate);
    return _startDateController.text = formattedDate;
  }

  @override
  void initState() {
    // getDateOnRecord();
    generateRandomAvgSpeed();
    generateRandomNUmberOfPassangers();
    generateFlightNumber();
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
      backgroundColor: Surface,
      appBar: CustomAppBar(
        title: 'Add Your Flight',
      ),
      body: SingleChildScrollView(
        child: Center(
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
                MyButton(
                    text: 'Add Record',
                    color: Colors.orange,
                    onTap: addFlightRecord),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
