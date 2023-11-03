// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sky_journal/global_util/transform_nationality.dart';

class MyCard extends StatelessWidget {
  final String certificationNumber;
  final String name;
  final String country;
  final String sex;
  final String weight;
  final String height;
  final String hairColor;
  final String eyeColor;
  final String dateOfExpiry;
  final String dateOfBirthDay;
  final String dateOfIssue;
  final Color? colorCard;

  const MyCard({
    Key? key,
    required this.name,
    required this.country,
    required this.sex,
    required this.weight,
    required this.height,
    required this.hairColor,
    required this.eyeColor,
    this.colorCard,
    required this.dateOfBirthDay,
    required this.dateOfIssue,
    required this.certificationNumber,
    required this.dateOfExpiry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NAME',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  'NATIONALITY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  transformNationalityName(country),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  certificationNumber,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
                Text(
                  dateOfBirthDay,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
                Text(
                  dateOfExpiry,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
                Text(
                  dateOfIssue,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sex',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
                Text(
                  sex,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WEIGHT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
                Text(
                  weight,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HEIGHT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
                Text(
                  height,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HAIR COLOR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
                Text(
                  hairColor,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EYE COLOR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
                Text(
                  eyeColor,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
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
