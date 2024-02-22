// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sky_journal/components/time_picker/minutes.dart';
import 'package:sky_journal/database/firestore.dart';
import 'package:sky_journal/global_util/getCurrentDate.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/global_widgets/my_button.dart';
import 'package:sky_journal/global_widgets/my_textfield.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../theme/color_theme.dart';

class AddDoctorAppointment extends StatefulWidget {
  const AddDoctorAppointment({super.key});

  @override
  State<AddDoctorAppointment> createState() => _AddDoctorAppointmentState();
}

class _AddDoctorAppointmentState extends State<AddDoctorAppointment> {
  DateTime today = DateTime.now();

  DateTime selectedTime = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;
    });
  }

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
  }

  void addDoctorAppointment() {
    if (_doctorNameController.text.isNotEmpty &&
        _timeTextController.text.isNotEmpty &&
        _specialityController.text.isNotEmpty) {
      String name = _doctorNameController.text;
      String time = _timeTextController.text;
      String speciality = _specialityController.text;
      DateTime date = today;
      database.addDoctorAppointment(
        name,
        date,
        time,
        speciality,
        "Upcoming",
      );
    }

    _doctorNameController.clear();
    _timeTextController.clear();
    _specialityController.clear();
  }

  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController _doctorNameController = TextEditingController();

  final TextEditingController _timeTextController = TextEditingController();

  final TextEditingController _specialityController = TextEditingController();

  // void _addDoctorAppointmentToDatabase() {
  //   if (_doctorNameController.text.isNotEmpty) {
  //     String name = _doctorNameController.text;
  //     database.addDoctorAppointment(
  //       name,
  //     );
  //   }

  //   _doctorNameController.clear();
  // }

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
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    TableCalendar(
                      focusedDay: today,
                      rowHeight: 48,
                      selectedDayPredicate: (day) => isSameDay(today, day),
                      headerStyle: HeaderStyle(
                        titleTextStyle: TextStyle(color: Colors.white),
                        formatButtonVisible: false,
                        titleCentered: true,
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                      ),
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      calendarStyle: CalendarStyle(
                        defaultTextStyle: TextStyle(color: Colors.white),
                        holidayTextStyle: TextStyle(color: Colors.white),
                        weekNumberTextStyle: TextStyle(color: Colors.white),
                        weekendTextStyle: TextStyle(color: Colors.white),
                      ),
                      onDaySelected: _onDaySelected,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Time: ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    MyTextField(
                        hintText: 'Time',
                        obscureText: false,
                        enabled: true,
                        controller: _timeTextController),
                    SizedBox(height: 20),
                    MyTextField(
                        hintText: 'Doctor Speciality',
                        obscureText: false,
                        enabled: true,
                        controller: _specialityController),
                    SizedBox(height: 20),
                    MyButton(
                      text: "Add Appoinment",
                      onTap: addDoctorAppointment,
                      color: Primary,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
