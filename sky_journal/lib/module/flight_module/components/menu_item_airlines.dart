import 'package:flutter/material.dart';

class DropdownMenuItemsAirLines {
  static DropdownMenuItem<String> buildMenuItemAirLines(String item) =>
      DropdownMenuItem(
        value: item,
        child: Row(
          children: [
            if (item == 'Private') ...[
              Icon(Icons.star, color: Colors.white),
              SizedBox(width: 10),
            ],
            Text(
              item,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
}
