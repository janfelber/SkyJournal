import 'package:flutter/material.dart';

class DropdownMenuItemsPilots {
  static DropdownMenuItem<String> buildMenuItemPilotFunctions(String item) =>
      DropdownMenuItem(
        value: item,
        child: Row(
          children: [
            if (item == 'Pilot In Command') ...[
              Container(
                  height: 30,
                  child: Image.asset('lib/icons/captain.png',
                      color: Colors.white)),
              SizedBox(width: 10),
            ],
            if (item == 'Co-Pilot') ...[
              Container(
                  height: 30,
                  child: Image.asset('lib/icons/co-pilot.png',
                      color: Colors.white)),
              SizedBox(width: 10),
            ],
            if (item == 'Dual') ...[
              Container(
                  height: 30,
                  child: Row(
                    children: [
                      Image.asset('lib/icons/co-pilot.png',
                          color: Colors.white),
                      Image.asset('lib/icons/co-pilot.png',
                          color: Colors.white),
                    ],
                  )),
              SizedBox(width: 10),
            ],
            if (item == 'Instructor') ...[
              Container(
                  height: 30,
                  child: Image.asset('lib/icons/instructor.png',
                      color: Colors.white)),
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
