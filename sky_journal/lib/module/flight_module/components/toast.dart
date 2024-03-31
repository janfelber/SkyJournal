import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(BuildContext context,
    {String? textToast,
    IconData? iconToast,
    String? imagePath,
    Color? textColor,
    Color? iconColor,
    Color? colorToast}) {
  FToast fToast = FToast();
  // Default text for toast
  final String displayText = textToast ?? "Default text for toast";
  final Widget displayIcon = iconToast != null
      ? Icon(
          iconToast,
          // Default icon color is black
          color: iconColor ?? Colors.black,
        )
      // Image path to display image icon
      : imagePath != null
          ? Image.asset(
              imagePath,
              width: 24,
              height: 24,
              color: iconColor,
            )
          : Container(); // Default empty container if no icon or image path is provided
  final Color displayColor = colorToast ?? Colors.green;
  final Color displayTextColor = textColor ?? Colors.black;
  fToast.init(context);

  Widget toast = Container(
    margin: const EdgeInsets.all(20.0), // Add margin for spacing
    padding: const EdgeInsets.symmetric(
        horizontal: 12.0, vertical: 12.0), // Add padding for content spacing
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0), // Round corners
      color: displayColor,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        displayIcon,
        SizedBox(
          width: 12.0,
        ),
        Flexible(
          child: Text(
            displayText,
            style: TextStyle(color: displayTextColor),
            overflow:
                TextOverflow.ellipsis, // Allow text to overflow with ellipsis
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.CENTER,
    toastDuration: Duration(seconds: 2),
  );
}
