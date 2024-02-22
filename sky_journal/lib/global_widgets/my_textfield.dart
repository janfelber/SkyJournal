// ignore_for_file: prefer_const_constructors, prefer_if_null_operators

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextStyle? textStyle;
  final String hintText;
  final TextStyle? hintTextStyle;
  final bool obscureText;
  final bool enabled;
  final TextEditingController controller;
  final Icon? icon;
  final VoidCallback? onPressed;
  final CupertinoButton? button;

  const MyTextField(
      {super.key,
      required this.hintText,
      this.onPressed,
      required this.obscureText,
      required this.enabled,
      required this.controller,
      this.hintTextStyle,
      this.button,
      this.icon,
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
        suffixIcon: icon != null
            ? IconButton(
                icon: icon!,
                onPressed: onPressed,
              )
            : null,
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
