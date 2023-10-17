import 'package:flutter/material.dart';
import 'package:sky_journal/theme/color_theme.dart';
import 'package:sky_journal/util/space.dart';

class FlightCard extends StatelessWidget {
  final String startDestination;
  final String endDestination;
  final String startDate;
  final String timeOfTakeOff;
  final String timeOfLanding;

  const FlightCard({
    Key? key,
    required this.startDestination,
    required this.endDestination,
    required this.startDate,
    required this.timeOfTakeOff,
    required this.timeOfLanding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
            Space.Y(15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeOfTakeOff + ' - ' + timeOfLanding,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: textColor,
                      ),
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
                Image.asset(
                  'assets/images/logo.png',
                  height: 24,
                ),
                Space.X(20),
                Text(
                  'Tus air',
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
