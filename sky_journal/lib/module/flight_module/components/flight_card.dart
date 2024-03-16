// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sky_journal/theme/color_theme.dart';
import 'package:sky_journal/module/flight_module/components/utils/airlines_convertor.dart';
import 'package:sky_journal/global_widgets/space.dart';

class FlightCard extends StatelessWidget {
  final VoidCallback? onEdit;
  final String startDestination;
  final String endDestination;
  final String startDate;
  final String timeOfTakeOff;
  final String timeOfLanding;
  final String airline;

  const FlightCard({
    Key? key,
    required this.startDestination,
    required this.endDestination,
    required this.startDate,
    required this.timeOfTakeOff,
    required this.timeOfLanding,
    required this.airline,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> parts = timeOfTakeOff.split(':');
    int hourTakeOff = int.parse(parts[0]);

    return Card(
      // Use a Card widget for the outer container
      elevation: 2,
      margin: EdgeInsets.only(bottom: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: cards,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  startDestination + ' - ' + endDestination,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: textColor.withOpacity(0.3),
                  ),
                ),
                Spacer(),
                GestureDetector(
                    onTap: onEdit,
                    child: Icon(Icons.edit, color: Colors.white, size: 20)),
              ],
            ),
            Space.Y(15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          timeOfTakeOff + ' - ' + timeOfLanding,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                        Space.X(10),
                        Icon(
                          //if time of takeoff is from 6:00 to 17:59 then show a sun icon else show a moon icon
                          hourTakeOff < 18 && hourTakeOff >= 6
                              ? Icons.sunny
                              : CupertinoIcons.moon_stars_fill,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Space.Y(10),
                    Text(
                      startDate,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
            Space.Y(15),
            Row(
              children: [
                getAirlineLogo(airline),
                Space.X(20),
                Text(
                  airline,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
