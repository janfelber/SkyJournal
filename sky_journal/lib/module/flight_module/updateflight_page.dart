// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/global_widgets/my_button.dart';
import 'package:sky_journal/module/flight_module/components/dialog_calendar.dart';
import 'package:sky_journal/module/flight_module/components/dialog_timer.dart';

import '../../database/firestore.dart';
import '../../global_widgets/my_textfield.dart';
import '../../theme/color_theme.dart';
import 'components/menu_item_airlines.dart';
import 'components/menu_item_pilots.dart';

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
                        builder: (context) => MyDialogCalendar(
                              selectedDate: selectedDate,
                              dialogText: 'Departure Date',
                              onDateSelected: (selectedDay) {
                                setState(() {
                                  selectedDate = selectedDay;
                                  _startDateController.text =
                                      DateFormat('d.M.yyyy')
                                          .format(selectedDay);
                                });
                              },
                            ));
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
                      builder: (context) => MyDialogCalendar(
                        selectedDate: selectedEndDate,
                        dialogText: 'Arrival Date',
                        onDateSelected: (selectedDay) {
                          setState(() {
                            selectedEndDate = selectedDay;
                            _endDateController.text =
                                DateFormat('d.M.yyyy').format(selectedDay);
                          });
                        },
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
                        builder: (context) => MyDialogTimer(
                            onTimeSelected: (selectedTime) {
                              setState(() {
                                _timeOfTakeOffController.text =
                                    DateFormat('HH:mm').format(selectedTime);
                              });
                            },
                            dialogText: 'Take Off Time'));
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
                      builder: (context) => MyDialogTimer(
                        onTimeSelected: (selectedTime) {
                          setState(() {
                            _timeOfLandingController.text =
                                DateFormat('HH:mm').format(selectedTime);
                          });
                        },
                        dialogText: 'Landing Time',
                      ),
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
                          .map((item) => DropdownMenuItemsPilots
                              .buildMenuItemPilotFunctions(item))
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
                      items: airlines
                          .map((item) =>
                              DropdownMenuItemsAirLines.buildMenuItemAirLines(
                                  item))
                          .toList(),
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
                MyButton(
                  text: 'Edit Flight',
                  onTap: editFlight,
                  color: Colors.orange,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
