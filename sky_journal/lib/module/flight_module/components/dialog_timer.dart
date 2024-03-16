// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/color_theme.dart';

class MyDialogTimer extends StatefulWidget {
  final Function(DateTime) onTimeSelected;
  final String dialogText;
  const MyDialogTimer(
      {super.key, required this.onTimeSelected, required this.dialogText});

  @override
  State<MyDialogTimer> createState() => _MyDialogTimerState();
}

class _MyDialogTimerState extends State<MyDialogTimer> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.dialogText,
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
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      widget.onTimeSelected(newDateTime);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
