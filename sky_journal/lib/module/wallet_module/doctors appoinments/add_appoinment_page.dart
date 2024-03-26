// ignore_for_file: prefer_const_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/database/firestore.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/global_widgets/my_button.dart';
import 'package:sky_journal/global_widgets/my_textfield.dart';
import 'package:sky_journal/module/flight_module/components/dialog_timer.dart';
import 'package:sky_journal/module/flight_module/components/toast.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../theme/color_theme.dart';

class AddDoctorAppointment extends StatefulWidget {
  final Function? onAppointmentAdded;
  const AddDoctorAppointment({Key? key, this.onAppointmentAdded})
      : super(key: key);

  @override
  State<AddDoctorAppointment> createState() => _AddDoctorAppointmentState();
}

class _AddDoctorAppointmentState extends State<AddDoctorAppointment> {
  DateTime today = DateTime.now();
  bool showCalendar = false;

  String? token;

  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _timeTextController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;
    });
  }

  DateTime selectedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    getToken();
    _timeTextController.text = DateFormat('HH:mm').format(today).toString();
  }

  //get fcm token
  Future<void> getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  void addDoctorAppointment() async {
    if (_doctorNameController.text.isNotEmpty &&
        _timeTextController.text.isNotEmpty &&
        _specialityController.text.isNotEmpty) {
      String name = _doctorNameController.text;
      String time = _timeTextController.text;
      String speciality = _specialityController.text;
      DateTime date = today;

      // Add the appointment to Firestore
      await database.addDoctorAppointment(
        name,
        date,
        time,
        speciality,
        "Upcoming",
        token!,
        false,
      );

      if (widget.onAppointmentAdded != null) {
        widget.onAppointmentAdded!();
      }
    } else {
      // Show Toast with an alert that all fields must be filled
      showToast(
        context,
        textToast: "Please fill in all fields",
        imagePath: 'lib/icons/doctor-problem.png',
        colorToast: Colors.red,
        textColor: Colors.white,
      );
      return; // End the function if any fields are empty
    }

    // Clear content of all fields
    _doctorNameController.clear();
    _timeTextController.clear();
    _specialityController.clear();

    // Navigate back to the previous page
    Navigator.pop(context);
  }

  // Schedule notification using Firebase Cloud Messaging

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Surface,
      appBar: CustomAppBar(
        title: 'Add Doctor Appointment',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MyTextField(
                  hintText: 'Name of Doctor',
                  obscureText: false,
                  enabled: true,
                  controller: _doctorNameController),
              SizedBox(height: 15),
              MyTextField(
                  hintText: 'Doctor Speciality',
                  obscureText: false,
                  enabled: true,
                  controller: _specialityController),
              SizedBox(height: 15),
              Column(
                children: [
                  Row(
                    children: [
                      Text('Date & Time',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: PopUp,
                    ),
                    child: Column(
                      children: [
                        CupertinoButton(
                          onPressed: () {
                            setState(() {
                              showCalendar = !showCalendar;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${DateFormat('dd MMM yyyy').format(today)}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                DateFormat('HH:mm')
                                    .format(selectedTime)
                                    .toString(),
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        if (showCalendar)
                          Container(
                            decoration: BoxDecoration(
                              color: PopUp,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                TableCalendar(
                                  focusedDay: today,
                                  rowHeight: 48,
                                  selectedDayPredicate: (day) =>
                                      isSameDay(today, day),
                                  headerStyle: HeaderStyle(
                                    titleTextStyle:
                                        TextStyle(color: Colors.white),
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                    leftChevronIcon: Icon(
                                      Icons
                                          .chevron_left, // ikona šipky směrem doleva
                                      color: Colors.white,
                                    ),
                                    rightChevronIcon: Icon(
                                      Icons
                                          .chevron_right, // ikona šipky směrem doprava
                                      color: Colors.white,
                                    ),
                                  ),
                                  firstDay: DateTime.utc(2010, 10, 16),
                                  lastDay: DateTime.utc(2030, 3, 14),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                    todayTextStyle:
                                        TextStyle(color: Colors.blue),
                                    todayDecoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    selectedDecoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  onDaySelected: _onDaySelected,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        "Time",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    CupertinoButton(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.black26,
                                        ),
                                        child: Text(
                                          DateFormat('HH:mm')
                                              .format(selectedTime)
                                              .toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => MyDialogTimer(
                                              onTimeSelected: (DateTime time) {
                                                setState(
                                                  () {
                                                    selectedTime = time;
                                                    _timeTextController.text =
                                                        DateFormat('HH:mm')
                                                            .format(time)
                                                            .toString();
                                                  },
                                                );
                                              },
                                              dialogText:
                                                  'Time Of Appointment'),
                                        );
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MyButton(
                text: "Add Appointment",
                onTap: addDoctorAppointment,
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
