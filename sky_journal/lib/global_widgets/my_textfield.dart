import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
  final bool readOnly;

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
    this.onPressed,
    this.readOnly = false,
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
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: icon != null && !readOnly
            ? IconButton(
                icon: icon!,
                onPressed: onPressed,
              )
            : icon,
        hintText: hintText,
        hintStyle: hintTextStyle == null
            ? TextStyle(color: Colors.white)
            : hintTextStyle,
        enabled: enabled,
      ),
      readOnly: readOnly,
      onTap: readOnly ? onPressed as void Function()? : null,
      obscureText: obscureText,
    );
  }
}
