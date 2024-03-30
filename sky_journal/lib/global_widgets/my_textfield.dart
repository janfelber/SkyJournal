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
  final bool numericInput;
  final int? maxLength;
  final bool readOnly;
  final Color? backgroundColor;
  final Color? enabledBorderColor; // Parameter for enabled border color
  final Color? focusedBorderColor; // Parameter for focused border color

  const MyTextField({
    Key? key,
    required this.hintText,
    required this.obscureText,
    required this.enabled,
    required this.controller,
    this.hintTextStyle,
    this.icon,
    this.textStyle,
    this.numericInput = false,
    this.maxLength,
    this.onPressed,
    this.readOnly = false,
    this.backgroundColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: textStyle,
      keyboardType: numericInput ? TextInputType.number : TextInputType.text,
      inputFormatters: [
        if (numericInput) FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: enabledBorderColor ??
                  Colors
                      .white), // Use the provided enabled border color or default to white
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: focusedBorderColor ??
                  Colors
                      .orange), // Use the provided focused border color or default to orange
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: backgroundColor,
        suffixIcon: icon != null && !readOnly
            ? IconButton(
                icon: icon!,
                onPressed: onPressed,
              )
            : icon,
        hintText: hintText,
        hintStyle: hintTextStyle,
        enabled: enabled,
      ),
      readOnly: readOnly,
      onTap: readOnly ? onPressed as void Function()? : null,
      obscureText: obscureText,
    );
  }
}
