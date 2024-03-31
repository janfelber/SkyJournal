// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/global_widgets/my_button.dart';
import 'package:sky_journal/global_widgets/my_textfield.dart';
import 'package:sky_journal/database/firestore.dart';
import 'package:sky_journal/module/flight_module/components/dialog_timer.dart';

import '../../theme/color_theme.dart';
import 'components/menu_item_airlines.dart';
import 'components/menu_item_pilots.dart';
import 'components/dialog_calendar.dart';
import 'components/toast.dart';

class AddFlightPage extends StatefulWidget {
  const AddFlightPage({Key? key}) : super(key: key);

  @override
  State<AddFlightPage> createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  String numOfPassengers = "0";

  String avgSpeed = "0";

  DateTime? selectedDate;

  DateTime? selectedEndDate;

// List of airlines
  final airlines = [
    'Private',
    'Air Canada',
    'British Airways',
    'Emirates',
    'Etihad Airways',
    'Japan Airlines',
    'Lufthansa',
    'Qatar Airways',
    'Ryanair',
    'Tus Airways',
    'Wizz Air',
  ];
// List of pilot functions
  final pilotFunctions = [
    'Pilot In Command',
    'Co-Pilot',
    'Dual',
    'Instructor',
  ];

  String? selectedAirline;

  String? selectedPilotFunction;

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

  final TextEditingController _typeOfAircraftController =
      TextEditingController();

  final TextEditingController _pilotFunctionController =
      TextEditingController();

  final TextEditingController _registrationController = TextEditingController();

  void addFlightRecord() {
    //if the start date is after the end date
    if (_startDateController.text.isNotEmpty &&
        _endDateController.text.isNotEmpty &&
        selectedDate!.isAfter(selectedEndDate!)) {
      showToast(
        context,
        textToast: 'Start date is after the end date',
        imagePath: 'lib/icons/calendar.png',
        colorToast: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    //if time of takeoff is after the time of landing
    if (_timeOfTakeOffController.text.isNotEmpty &&
        _timeOfLandingController.text.isNotEmpty &&
        _timeOfTakeOffController.text.compareTo(_timeOfLandingController.text) >
            0) {
      showToast(
        context,
        textToast: 'Start time is after end time',
        imagePath: 'lib/icons/time.png',
        colorToast: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    // //if destinations are the same
    if (_startDestinationController.text.isNotEmpty &&
        _endDestinationController.text.isNotEmpty &&
        _startDestinationController.text.toUpperCase() ==
            _endDestinationController.text.toUpperCase()) {
      showToast(
        context,
        textToast: 'Start and End are the same',
        imagePath: 'lib/icons/destination.png',
        colorToast: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    //if the start departure time is same as the end departure time
    if (_timeOfTakeOffController.text.isNotEmpty &&
        _timeOfLandingController.text.isNotEmpty &&
        _timeOfTakeOffController.text == _timeOfLandingController.text) {
      showToast(
        context,
        textToast: 'Identical takeoff and landing times',
        imagePath: 'lib/icons/time.png',
        colorToast: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_flightNumberController.text.isNotEmpty &&
        _startDateController.text.isNotEmpty &&
        _endDateController.text.isNotEmpty &&
        _startDestinationController.text.isNotEmpty &&
        _endDestinationController.text.isNotEmpty &&
        _timeOfTakeOffController.text.isNotEmpty &&
        _timeOfLandingController.text.isNotEmpty &&
        _airlineController.text.isNotEmpty &&
        _typeOfAircraftController.text.isNotEmpty &&
        _pilotFunctionController.text.isNotEmpty &&
        _registrationController.text.isNotEmpty) {
      String flightNumber = _flightNumberController.text;
      String startDate = _startDateController.text;
      String endDate = _endDateController.text;
      String startDestination = _startDestinationController.text;
      String endDestination = _endDestinationController.text;
      String timeOfTakeOff = _timeOfTakeOffController.text;
      String timeOfLanding = _timeOfLandingController.text;
      String airline = _airlineController.text;
      String typeOfAircraft = _typeOfAircraftController.text;
      String pilotFunction = _pilotFunctionController.text;
      String registration = _registrationController.text;
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
        typeOfAircraft,
        pilotFunction,
        registration,
      );

      // Delete the text from the text fields
      _flightNumberController.clear();
      _startDateController.clear();
      _endDateController.clear();
      _startDestinationController.clear();
      _endDestinationController.clear();
      _timeOfTakeOffController.clear();
      _timeOfLandingController.clear();
      _airlineController.clear();
      _typeOfAircraftController.clear();
      _pilotFunctionController.clear();
      _registrationController.clear();

      // Go back to the previous page
      Navigator.pop(context);
    } else {
      showToast(
        context,
        textToast: 'Please fill in all fields',
        imagePath: 'lib/icons/accident.png',
        colorToast: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Generate a random number of passengers - no access to real data
  String generateRandomNUmberOfPassangers() {
    Random rnd;
    int min = 170;
    int max = 388;
    rnd = new Random();
    int numberOfPassangers = min + rnd.nextInt(max - min);
    numOfPassengers = numberOfPassangers.toString();
    return numOfPassengers;
  }

  // Generate a random average speed - no access to real data
  String generateRandomAvgSpeed() {
    Random rnd;
    int min = 800;
    int max = 1000;
    rnd = new Random();
    int averageSpeed = min + rnd.nextInt(max - min);
    avgSpeed = averageSpeed.toString();
    return avgSpeed;
  }

  // Generate a random flight number - no access to real data
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

  @override
  void initState() {
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
    _typeOfAircraftController.dispose();
    _pilotFunctionController.dispose();
    _registrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    return Scaffold(
      backgroundColor: Surface,
      appBar: CustomAppBar(
        title: 'Add Your Flight',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextField(
                  controller: _flightNumberController,
                  hintText: 'Flight Number',
                  obscureText: false,
                  enabled: false,
                  textStyle: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  controller: _startDateController,
                  hintText: 'Date of Departure',
                  obscureText: false,
                  enabled: true,
                  readOnly: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  hintTextStyle: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                  backgroundColor: Colors.transparent,
                  enabledBorderColor: Colors.grey[700],
                  focusedBorderColor: Colors.grey[700],
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => MyDialogCalendar(
                        selectedDate: selectedDate,
                        onDateSelected: (selectedDay) {
                          setState(() {
                            selectedDate = selectedDay;
                            _startDateController.text =
                                DateFormat('d.M.yyyy').format(selectedDay);
                          });
                        },
                        dialogText: 'Departure Date',
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  controller: _endDateController,
                  hintText: 'Date of Arrival',
                  obscureText: false,
                  enabled: true,
                  readOnly: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  hintTextStyle: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                  backgroundColor: Colors.transparent,
                  enabledBorderColor: Colors.grey[700],
                  focusedBorderColor: Colors.grey[700],
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => MyDialogCalendar(
                              selectedDate: selectedEndDate,
                              onDateSelected: (selectedDay) {
                                setState(() {
                                  selectedEndDate = selectedDay;
                                  _endDateController.text =
                                      DateFormat('d.M.yyyy')
                                          .format(selectedDay);
                                });
                              },
                              dialogText: 'Arrival Date',
                            ));
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  controller: _startDestinationController,
                  hintText: 'Start Destination',
                  enabled: true,
                  obscureText: false,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  hintTextStyle: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                  backgroundColor: Colors.transparent,
                  enabledBorderColor: Colors.grey[700],
                  focusedBorderColor: Colors.grey[700],
                ),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  controller: _endDestinationController,
                  hintText: 'End Destination',
                  obscureText: false,
                  enabled: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  hintTextStyle: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                  backgroundColor: Colors.transparent,
                  enabledBorderColor: Colors.grey[700],
                  focusedBorderColor: Colors.grey[700],
                ),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  controller: _timeOfTakeOffController,
                  hintText: 'Time of Take Off',
                  obscureText: false,
                  enabled: true,
                  readOnly: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  hintTextStyle: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                  backgroundColor: Colors.transparent,
                  enabledBorderColor: Colors.grey[700],
                  focusedBorderColor: Colors.grey[700],
                  icon: Icon(Icons.access_time, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => MyDialogTimer(
                        onTimeSelected: (selectedTime) {
                          setState(() {
                            _timeOfTakeOffController.text =
                                DateFormat('HH:mm').format(selectedTime);
                          });
                        },
                        dialogText: 'Take Off Time',
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  controller: _timeOfLandingController,
                  hintText: 'Time of Landing',
                  obscureText: false,
                  enabled: true,
                  readOnly: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  hintTextStyle: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                  backgroundColor: Colors.transparent,
                  enabledBorderColor: Colors.grey[700],
                  focusedBorderColor: Colors.grey[700],
                  icon: Icon(Icons.access_time, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => MyDialogTimer(
                        onTimeSelected: (selectedTime) {
                          setState(() {
                            _timeOfLandingController.text =
                                DateFormat('HH:mm').format(selectedTime);
                          });
                        },
                        dialogText: 'Land Time',
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  controller: _typeOfAircraftController,
                  hintText: 'Type of Aircraft',
                  obscureText: false,
                  enabled: true,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  hintTextStyle: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                  backgroundColor: Colors.transparent,
                  enabledBorderColor: Colors.grey[700],
                  focusedBorderColor: Colors.grey[700],
                ),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  hintText: 'Registration',
                  obscureText: false,
                  enabled: true,
                  controller: _registrationController,
                  textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  hintTextStyle: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                  backgroundColor: Colors.transparent,
                  enabledBorderColor: Colors.grey[700],
                  focusedBorderColor: Colors.grey[700],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width *
                        0.02, // Adjust the horizontal padding
                    vertical:
                        screenSize.height * 0.01, // Adjust the vertical padding
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        screenSize.width * 0.03), // Adjust the border radius
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedPilotFunction,
                      dropdownColor: PopUp,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      iconSize: screenSize.width * 0.06,
                      hint: Text(
                        'Select Pilot Function',
                        style: TextStyle(color: Colors.white),
                      ),
                      items: pilotFunctions
                          .map((item) => DropdownMenuItemsPilots
                              .buildMenuItemPilotFunctions(item))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPilotFunction = value;
                          _pilotFunctionController.text =
                              selectedPilotFunction!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width *
                        0.02, // Adjust the horizontal padding
                    vertical:
                        screenSize.height * 0.01, // Adjust the vertical padding
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        screenSize.width * 0.03), // Adjust the border radius
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedAirline,
                      dropdownColor: PopUp,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      iconSize: screenSize.width * 0.06,
                      hint: Text(
                        'Select Airline',
                        style: TextStyle(color: Colors.white),
                      ),
                      items: airlines
                          .map((item) =>
                              DropdownMenuItemsAirLines.buildMenuItemAirLines(
                                  item))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAirline = value;
                          _airlineController.text = selectedAirline!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 20.0,
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
