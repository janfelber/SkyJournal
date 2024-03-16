// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../theme/color_theme.dart';

class MyDialogCalendar extends StatefulWidget {
  DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String dialogText;

  MyDialogCalendar({
    Key? key,
    required this.selectedDate,
    required this.dialogText,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<MyDialogCalendar> createState() => _MyDialogCalendarState();
}

class _MyDialogCalendarState extends State<MyDialogCalendar> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: PopUp,
      title: Text(
        widget.dialogText,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      content: Container(
        height: 410,
        width: 300,
        child: TableCalendar(
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
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
                _selectedDate = selectedDay;
                widget.onDateSelected(selectedDay);
              });
              Navigator.pop(context); // Close the dialog after date selection
            }
          },
          calendarStyle: CalendarStyle(
            defaultTextStyle: TextStyle(color: Colors.white),
            holidayTextStyle: TextStyle(color: Colors.white),
            weekNumberTextStyle: TextStyle(color: Colors.white),
            weekendTextStyle: TextStyle(color: Colors.white),
            selectedTextStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            todayTextStyle: TextStyle(color: Colors.blue),
            todayDecoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          focusedDay: _selectedDate,
          firstDay: DateTime(2000),
          lastDay: DateTime(2050),
        ),
      ),
    );
  }
}
