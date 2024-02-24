// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/global_widgets/my_button.dart';
import 'package:sky_journal/global_widgets/my_textfield.dart';
import 'package:sky_journal/database/firestore.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../theme/color_theme.dart';

class AddFlightPage extends StatefulWidget {
  const AddFlightPage({Key? key}) : super(key: key);

  @override
  State<AddFlightPage> createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  String numOfPassengers = "0";

  String avgSpeed = "0";

  final airlines = [
    'Air Canada',
    'Air France',
    'British Airways',
    'EasyJet',
    'Emirates',
    'Etihad Airways',
    'Japan Airlines',
    'Lufthansa',
    'Personal',
    'Qatar Airways',
    'Ryanair',
    'Tus Airways',
    'United Airlines',
    'Wizz Air',
  ];

  String? selectedAirline;

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

  void _handleAirlineSelection(String selectedAirline) {
    print('Selected Airline: $selectedAirline');
    // Tu by ste mohli vykonať ďalšie akcie na základe výberu leteckej spoločnosti
  }

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
                ),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  controller: _startDateController,
                  hintText: 'Date of Departure',
                  obscureText: false,
                  enabled: true,
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            backgroundColor: PopUp,
                            title: Text("Departure Date",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            content: Container(
                                height: 410,
                                width: 300,
                                child: TableCalendar(
                                  selectedDayPredicate: (day) =>
                                      isSameDay(DateTime.now(), day),
                                  headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                    titleTextStyle:
                                        TextStyle(color: Colors.white),
                                    leftChevronIcon: Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                    ),
                                    rightChevronIcon: Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDaySelected: (selectedDay, focusedDay) {
                                    if (selectedDay != null) {
                                      _startDateController.text =
                                          DateFormat('d.M.yyyy')
                                              .format(selectedDay);
                                      Navigator.pop(
                                          context); // Zavrieť dialóg po výbere dátumu
                                    }
                                  },
                                  calendarStyle: CalendarStyle(
                                    defaultTextStyle:
                                        TextStyle(color: Colors.white),
                                    holidayTextStyle:
                                        TextStyle(color: Colors.white),
                                    weekNumberTextStyle:
                                        TextStyle(color: Colors.white),
                                    weekendTextStyle:
                                        TextStyle(color: Colors.white),
                                    selectedTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    todayTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  focusedDay: DateTime.now(),
                                  firstDay: DateTime(2000),
                                  lastDay: DateTime(2050),
                                ))));
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
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            backgroundColor: PopUp,
                            title: Text("Arrival Date",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            content: Container(
                                height: 410,
                                width: 300,
                                child: TableCalendar(
                                  selectedDayPredicate: (day) =>
                                      isSameDay(DateTime.now(), day),
                                  headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                    titleTextStyle:
                                        TextStyle(color: Colors.white),
                                    leftChevronIcon: Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                    ),
                                    rightChevronIcon: Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDaySelected: (selectedDay, focusedDay) {
                                    if (selectedDay != null) {
                                      _endDateController.text =
                                          DateFormat('d.M.yyyy')
                                              .format(selectedDay);
                                      Navigator.pop(
                                          context); // Zavrieť dialóg po výbere dátumu
                                    }
                                  },
                                  calendarStyle: CalendarStyle(
                                    defaultTextStyle:
                                        TextStyle(color: Colors.white),
                                    holidayTextStyle:
                                        TextStyle(color: Colors.white),
                                    weekNumberTextStyle:
                                        TextStyle(color: Colors.white),
                                    weekendTextStyle:
                                        TextStyle(color: Colors.white),
                                    selectedTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    todayTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  focusedDay: DateTime.now(),
                                  firstDay: DateTime(2000),
                                  lastDay: DateTime(2050),
                                ))));
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
                  icon: Icon(Icons.access_time, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Take Off Time',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          backgroundColor: PopUp,
                          content: Container(
                            height: 200,
                            child: CupertinoTheme(
                              data: CupertinoThemeData(
                                textTheme: CupertinoTextThemeData(
                                  dateTimePickerTextStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.time,
                                      use24hFormat: true,
                                      onDateTimeChanged:
                                          (DateTime newDateTime) {
                                        setState(() {
                                          // Handle selected time
                                          _timeOfTakeOffController.text =
                                              DateFormat('HH:mm')
                                                  .format(newDateTime);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
                  icon: Icon(Icons.access_time, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Land Time',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          backgroundColor: PopUp,
                          content: Container(
                            height: 200,
                            child: CupertinoTheme(
                              data: CupertinoThemeData(
                                textTheme: CupertinoTextThemeData(
                                  dateTimePickerTextStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.time,
                                      use24hFormat: true,
                                      onDateTimeChanged:
                                          (DateTime newDateTime) {
                                        setState(() {
                                          // Handle selected time
                                          _timeOfLandingController.text =
                                              DateFormat('HH:mm')
                                                  .format(newDateTime);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 15.0,
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
                      items: airlines.map(buildMenuItem).toList(),
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

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.white),
        ),
      );
}
