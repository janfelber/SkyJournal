import 'package:flutter/material.dart';

class DropdownMenuItemGenders {
  static DropdownMenuItem<String> buildMenuItemGenders(String item) =>
      DropdownMenuItem(
        value: item,
        child: Row(
          children: [
            if (item == 'Female') ...[
              Icon(Icons.female, color: Colors.white),
              SizedBox(width: 10),
            ],
            if (item == 'Male') ...[
              Icon(Icons.male, color: Colors.white),
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
