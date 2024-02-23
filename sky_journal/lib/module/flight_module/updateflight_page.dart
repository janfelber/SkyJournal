// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';

import '../../global_widgets/my_textfield.dart';
import '../../theme/color_theme.dart';

class UpadateFlight extends StatefulWidget {
  final String flightNumber;
  final String startDate;
  final String endDate;
  final String startDestination;
  final String endDestination;
  final String timeOfTakeOff;
  final String timeOfLanding;
  final String airline;

  const UpadateFlight(
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
  State<UpadateFlight> createState() => _UpadateFlightState();
}

class _UpadateFlightState extends State<UpadateFlight> {
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

  @override
  void initState() {
    super.initState();
    _flightNumberController.text = widget.flightNumber;
    _startDateController.text = widget.startDate;
    _endDateController.text = widget.endDate;
    _startDestinationController.text = widget.startDestination;
    _endDestinationController.text = widget.endDestination;
    _timeOfTakeOffController.text = widget.timeOfTakeOff;
    _timeOfLandingController.text = widget.timeOfLanding;
    _airlineController.text = widget.airline;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Update Flight',
      ),
      backgroundColor: Surface,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
            child: Column(
              children: [
                Text('Flight Number: ${widget.flightNumber}'),
                MyTextField(
                  hintText: 'Flight Number',
                  controller: _flightNumberController,
                  obscureText: false,
                  enabled: false,
                ),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  hintText: 'Date of Departure',
                  controller: _startDateController,
                  obscureText: false,
                  enabled: true,
                ),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                    hintText: 'Date of Arrival',
                    obscureText: false,
                    enabled: true,
                    controller: _endDateController),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                    hintText: 'Start Destination',
                    obscureText: false,
                    enabled: true,
                    controller: _startDestinationController),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                    hintText: 'End Destination',
                    obscureText: false,
                    enabled: true,
                    controller: _endDestinationController),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                    hintText: 'Time of Take Off',
                    obscureText: false,
                    enabled: true,
                    controller: _timeOfTakeOffController),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                    hintText: 'Time of Landing',
                    obscureText: false,
                    enabled: true,
                    controller: _timeOfLandingController),
                SizedBox(
                  height: 10.0,
                ),
                Text('Airline: ${widget.airline}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
