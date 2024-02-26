// ignore_for_file: prefer_const_constructors, prefer_if_null_operators

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final bool numericInput; // Volitelný parametr pro povolení číselného vstupu
  final int?
      maxLength; // Volitelný parametr pro nastavení maximální délky řetězce

  const MyTextField({
    Key? key, // Opravený parametr key
    required this.hintText,
    required this.obscureText,
    required this.enabled,
    required this.controller,
    this.hintTextStyle,
    this.button,
    this.icon,
    this.textStyle,
    this.numericInput =
        false, // Nastavení výchozí hodnoty pro volitelný parametr numericInput
    this.maxLength, // Nastavení volitelného parametru maxLength
    this.onPressed,
  }) : super(key: key); // Přidání super volání pro key

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: textStyle == null ? TextStyle(color: Colors.white) : textStyle,
      keyboardType: numericInput
          ? TextInputType.number
          : TextInputType
              .text, // Dynamicky nastavte klávesnici podle volitelného parametru
      inputFormatters: [
        if (numericInput)
          FilteringTextInputFormatter.allow(RegExp(
              r'[0-9]')), // Povolit pouze čísla, pokud je zapnutý volitelný parametr
        if (maxLength != null)
          LengthLimitingTextInputFormatter(
              maxLength), // Omezení maximální délky, pokud je zadán volitelný parametr
      ],
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
