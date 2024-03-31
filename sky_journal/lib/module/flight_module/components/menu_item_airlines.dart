import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Dropdown menu items for airlines
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
            if (item == 'Air Canada') ...[
              SvgPicture.asset(
                'assets/airlines/Air_Canada.svg',
                height: 25,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'British Airways') ...[
              SvgPicture.asset(
                'assets/airlines/British.svg',
                height: 25,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Emirates') ...[
              SvgPicture.asset(
                'assets/airlines/Emirates.svg',
                height: 25,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Etihad Airways') ...[
              SvgPicture.asset(
                'assets/airlines/Etihad.svg',
                height: 25,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Japan Airlines') ...[
              Image.asset(
                'assets/airlines/japan-airlines_logo.png',
                height: 25,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Lufthansa') ...[
              SvgPicture.asset(
                'assets/airlines/Lufthansa.svg',
                height: 25,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Qatar Airways') ...[
              SvgPicture.asset(
                'assets/airlines/Qatar.svg',
                height: 25,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Ryanair') ...[
              Image.asset(
                'assets/airlines/ryanair_logo.png',
                height: 25,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Tus Airways') ...[
              Image.asset(
                'assets/airlines/tus-airways_logo.png',
                height: 25,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Wizz Air') ...[
              SvgPicture.asset(
                'assets/airlines/Wizz_Air_UK.svg',
                height: 25,
              ),
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
