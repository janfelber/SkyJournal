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
  final bool numericInput;
  final int? maxLength;
  final bool isDate; // Přidán parametr pro nastavení vstupu jako datum
  final String? dateFormat; // Přidán parametr pro formát data

  const MyTextField({
    Key? key,
    required this.hintText,
    required this.obscureText,
    required this.enabled,
    required this.controller,
    this.hintTextStyle,
    this.button,
    this.icon,
    this.textStyle,
    this.numericInput = false,
    this.maxLength,
    this.isDate = false,
    this.dateFormat, // Přidán parametr pro formát data
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: textStyle == null ? TextStyle(color: Colors.white) : textStyle,
      keyboardType: numericInput ? TextInputType.number : TextInputType.text,
      inputFormatters: [
        if (numericInput) FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        if (isDate && dateFormat != null)
          FilteringTextInputFormatter.deny(RegExp(r'[^\d' + dateFormat! + ']')),
        // Pokud je nastavený parametr isDate a dateFormat, použije se zde daný formát data
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
