// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/global_widgets/my_button.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../database/firestore.dart';
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
  final String typeOfAircraft;
  final String pilotFunction;

  const UpadateFlight(
      {super.key,
      required this.flightNumber,
      required this.startDate,
      required this.endDate,
      required this.startDestination,
      required this.endDestination,
      required this.timeOfTakeOff,
      required this.timeOfLanding,
      required this.airline,
      required this.typeOfAircraft,
      required this.pilotFunction});

  @override
  State<UpadateFlight> createState() => _UpadateFlightState();
}

class _UpadateFlightState extends State<UpadateFlight> {
  DateTime? selectedDate;

  DateTime? selectedEndDate;

  String? selectedAirline;

  String? selectedPilotFunction;

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

  final pilotFunctions = [
    'Pilot In Command',
    'Co-Pilot',
    'Dual',
    'Instructor',
  ];

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

  final TextEditingController _typeOfAircraftController =
      TextEditingController();

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
    _typeOfAircraftController.text = widget.typeOfAircraft;

    selectedDate = _parseDate(widget.startDate);
    selectedEndDate = _parseDate(widget.endDate);
    selectedAirline = widget.airline;
    selectedPilotFunction = widget.pilotFunction;
  }

  DateTime? _parseDate(String date) {
    try {
      // Rozdelíme dátum na časti
      List<String> parts = date.split('.');
      // Ak máme 3 časti, môžeme získať dátum
      if (parts.length == 3) {
        // Konvertujeme časti na čísla a vytvoríme DateTime objekt
        int year = int.parse(parts[2]);
        int month = int.parse(parts[1]);
        int day = int.parse(parts[0]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      print('Invalid date format: $date');
    }
    return null; // Ak sa nepodarilo parsovať dátum, vrátime null
  }

  //edit flight
  void editFlight() {
    // Získanie aktualizovaných údajov z kontrolórov
    String flightNumber = _flightNumberController.text;
    String startDate = _startDateController.text;
    String endDate = _endDateController.text;
    String startDestination = _startDestinationController.text;
    String endDestination = _endDestinationController.text;
    String timeOfTakeOff = _timeOfTakeOffController.text;
    String timeOfLanding = _timeOfLandingController.text;
    String airline = selectedAirline!;
    String typeOfAircraft = _typeOfAircraftController.text;
    String pilotFunction = selectedPilotFunction!;

    // Aktualizácia údajov v Firestore
    database.updateFlight(
      flightNumber,
      startDate,
      endDate,
      startDestination,
      endDestination,
      timeOfTakeOff,
      timeOfLanding,
      airline,
      typeOfAircraft,
      pilotFunction,
    );

    // Odoslanie aktualizovaných údajov späť na predchádzajúcu stránku
    Navigator.pop(context, {
      'flightNumber': flightNumber,
      'startDate': startDate,
      'endDate': endDate,
      'startDestination': startDestination,
      'endDestination': endDestination,
      'timeOfTakeOff': timeOfTakeOff,
      'timeOfLanding': timeOfLanding,
      'airline': airline,
      'typeOfAircraft': typeOfAircraft,
      'pilotFunction': pilotFunction,
    });
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
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor:
                            PopUp, // Prispôsobte farbu podľa svojich potrieb
                        title: Text(
                          "Departure Date",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        content: Container(
                          height: 410,
                          width: 300,
                          child: TableCalendar(
                            selectedDayPredicate: (day) =>
                                isSameDay(selectedDate ?? DateTime.now(), day),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: TextStyle(color: Colors.white),
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
                                setState(() {
                                  selectedDate = selectedDay;
                                  _startDateController.text =
                                      DateFormat('dd.M.yyyy')
                                          .format(selectedDate!);
                                });
                                Navigator.pop(context);
                              }
                            },
                            calendarStyle: CalendarStyle(
                              defaultTextStyle: TextStyle(color: Colors.white),
                              holidayTextStyle: TextStyle(color: Colors.white),
                              weekNumberTextStyle:
                                  TextStyle(color: Colors.white),
                              weekendTextStyle: TextStyle(color: Colors.white),
                              selectedTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              todayTextStyle: TextStyle(
                                color: Colors.blue,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            focusedDay: selectedDate ?? DateTime.now(),
                            firstDay: DateTime(2000),
                            lastDay: DateTime(2050),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                MyTextField(
                  hintText: 'Date of Arrival',
                  obscureText: false,
                  enabled: true,
                  controller: _endDateController,
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor:
                            PopUp, // Prispôsobte farbu podľa svojich potrieb
                        title: Text(
                          "Departure Date",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        content: Container(
                          height: 410,
                          width: 300,
                          child: TableCalendar(
                            selectedDayPredicate: (day) => isSameDay(
                                selectedEndDate ?? DateTime.now(), day),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: TextStyle(color: Colors.white),
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
                                setState(() {
                                  selectedEndDate = selectedDay;
                                  _endDateController.text =
                                      DateFormat('dd.M.yyyy')
                                          .format(selectedEndDate!);
                                });
                                Navigator.pop(context);
                              }
                            },
                            calendarStyle: CalendarStyle(
                              defaultTextStyle: TextStyle(color: Colors.white),
                              holidayTextStyle: TextStyle(color: Colors.white),
                              weekNumberTextStyle:
                                  TextStyle(color: Colors.white),
                              weekendTextStyle: TextStyle(color: Colors.white),
                              selectedTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              todayTextStyle: TextStyle(
                                color: Colors.blue,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            focusedDay: selectedEndDate ?? DateTime.now(),
                            firstDay: DateTime(2000),
                            lastDay: DateTime(2050),
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
                  controller: _timeOfTakeOffController,
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
                                      initialDateTime: DateFormat('HH:mm')
                                          .parse(_timeOfTakeOffController.text),
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
                  hintText: 'Time of Landing',
                  obscureText: false,
                  enabled: true,
                  controller: _timeOfLandingController,
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
                                      initialDateTime: DateFormat('HH:mm')
                                          .parse(_timeOfLandingController.text),
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
                  height: 10.0,
                ),
                MyTextField(
                    hintText: 'Type of Aircraft',
                    obscureText: false,
                    enabled: true,
                    controller: _typeOfAircraftController),
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
                      items: pilotFunctions
                          .map(buildMenuItemPilotFunctions)
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPilotFunction = value;
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
                      items: airlines.map(buildMenuItemAirlines).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAirline = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                MyButton(text: 'Edit Flight', onTap: editFlight, color: Primary)
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItemAirlines(String item) =>
      DropdownMenuItem(
        value: item,
        child: Row(
          children: [
            if (item == 'Private') ...[
              Icon(Icons.star, color: Colors.white),
              SizedBox(width: 10),
            ],
            Text(
              item,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
  DropdownMenuItem<String> buildMenuItemPilotFunctions(String item) =>
      DropdownMenuItem(
        value: item,
        child: Row(
          children: [
            if (item == 'Pilot In Command') ...[
              Container(
                  height: 30,
                  child: Image.asset('lib/icons/captain.png',
                      color: Colors.white)),
              SizedBox(width: 10),
            ],
            if (item == 'Co-Pilot') ...[
              Container(
                  height: 30,
                  child: Image.asset('lib/icons/co-pilot.png',
                      color: Colors.white)),
              SizedBox(width: 10),
            ],
            if (item == 'Dual') ...[
              Container(
                  height: 30,
                  child: Row(
                    children: [
                      Image.asset('lib/icons/co-pilot.png',
                          color: Colors.white),
                      Image.asset('lib/icons/co-pilot.png',
                          color: Colors.white),
                    ],
                  )),
              SizedBox(width: 10),
            ],
            if (item == 'Instructor') ...[
              Container(
                  height: 30,
                  child: Image.asset('lib/icons/instructor.png',
                      color: Colors.white)),
              SizedBox(width: 10),
            ],
            Text(
              item,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
}
