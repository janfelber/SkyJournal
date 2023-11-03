// ignore_for_file: prefer_const_constructors, prefer_if_null_operators

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextStyle? textStyle;
  final String hintText;
  final TextStyle? hintTextStyle;
  final bool obscureText;
  final bool enabled;
  final TextEditingController controller;

  const MyTextField(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.enabled,
      required this.controller,
      this.hintTextStyle,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: textStyle == null ? TextStyle(color: Colors.white) : textStyle,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
        hintStyle: hintTextStyle == null
            ? TextStyle(color: Colors.white)
            : hintTextStyle,
        enabled: enabled,
      ),
      obscureText: obscureText,
    );
  }
}
