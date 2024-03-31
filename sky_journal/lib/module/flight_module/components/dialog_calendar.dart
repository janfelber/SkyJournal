// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../theme/color_theme.dart';

class MyDialogCalendar extends StatefulWidget {
  DateTime? selectedDate; // The date that is selected by default
  final Function(DateTime)
      onDateSelected; // Callback function for date selection
  final String dialogText; // Text displayed in the dialog
  final Color? dialogTextColor; // Color of the dialog text
  final Color? backgroundColor; // Background color of the dialog
  final Color? titleCalendarColor; // Color of the calendar title
  final Color? leftChevronIconColor; // Color of the left chevron icon
  final Color? rightChevronIconColor; // Color of the right chevron icon
  final Color? defaultTextStyleColor; // Color of the default text style
  final Color? holidayTextStyleColor; // Color of the holiday text style
  final Color? weekNumberTextStyle; // Color of the week number text style
  final Color? weekendTextStyle; // Color of the weekend text style
  final Color? selectedTextStyle; // Color of the selected text style

  MyDialogCalendar({
    Key? key,
    required this.selectedDate,
    required this.dialogText,
    required this.onDateSelected,
    this.backgroundColor,
    this.defaultTextStyleColor,
    this.holidayTextStyleColor,
    this.weekNumberTextStyle,
    this.selectedTextStyle,
    this.weekendTextStyle,
    this.dialogTextColor,
    this.titleCalendarColor,
    this.leftChevronIconColor,
    this.rightChevronIconColor,
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
      backgroundColor: widget.backgroundColor ?? PopUp,
      title: Text(
        widget.dialogText,
        style: TextStyle(
            color: widget.dialogTextColor ?? Colors.white, fontSize: 20),
      ),
      content: Container(
        height: 410,
        width: 300,
        child: TableCalendar(
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle:
                TextStyle(color: widget.titleCalendarColor ?? Colors.white),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: widget.leftChevronIconColor ?? Colors.white,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: widget.rightChevronIconColor ?? Colors.white,
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
            defaultTextStyle:
                // Set the default text style color to white
                TextStyle(color: widget.defaultTextStyleColor ?? Colors.white),
            holidayTextStyle:
                // Set the holiday text style color to white
                TextStyle(color: widget.holidayTextStyleColor ?? Colors.white),
            weekNumberTextStyle:
                // Set the week number text style color to white
                TextStyle(color: widget.weekNumberTextStyle ?? Colors.white),
            weekendTextStyle:
                // Set the weekend text style color to white
                TextStyle(color: widget.weekendTextStyle ?? Colors.white),
            selectedTextStyle: TextStyle(
                // Set the selected text style color to white
                color: widget.selectedTextStyle ?? Colors.white,
                fontWeight: FontWeight.bold),
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
