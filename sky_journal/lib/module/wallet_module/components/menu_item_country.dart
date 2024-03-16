import 'package:flutter/material.dart';

class DropdownMenuItemCountries {
  static DropdownMenuItem<String> buildMenuItemCountries(String item) =>
      DropdownMenuItem(
        value: item,
        child: Row(
          children: [
            Text(
              item,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
}
