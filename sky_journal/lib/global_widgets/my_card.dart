// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sky_journal/global_util/transform_gender.dart';
import 'package:sky_journal/global_util/transform_nationality.dart';

import '../global_util/get_country_flag.dart';

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
          color: Colors.green,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  country,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                getCountryFlag(country) ??
                    Container(), // show country flag based on country name
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'DEPARTMENT OF TRANSPORTATION ■ WORLDWIDE AVIATION ADMINISTRATION',
                style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold, height: 0),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold, height: 0),
                ),
              ],
            ),
            SizedBox(
              height: 13,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Natinality ',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              height: 0),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          transformNationalityName(country),
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              height: 0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'D.O.B',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              height: 0),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          dateOfBirthDay, //date of birth from database
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              height: 0),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 25,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Sex',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 0),
                        ),
                        Text(
                          transformGender(sex),
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 0),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Column(
                      children: [
                        Text(
                          'Height ',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 0),
                        ),
                        Text(
                          height,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 0),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Column(
                      children: [
                        Text(
                          'Weight ',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 0),
                        ),
                        Text(
                          weight,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 0),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Column(
                      children: [
                        Text(
                          'Hair ',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 0),
                        ),
                        Text(
                          hairColor,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 0),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Column(
                      children: [
                        Text(
                          'Eyes ',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 0),
                        ),
                        Text(
                          eyeColor,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 0),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              children: [
                Text(
                  'Has been found to be properly to exercise the privilege of',
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800),
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text('|  ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, height: 0, fontSize: 11)),
                Text(
                  'STUDENT PILOT',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold, height: 0),
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  '|| Certificate Number',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, height: 0, fontSize: 11),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  certificationNumber,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold, height: 0),
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  '||| Date of Expiry                ',
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold, height: 0),
                ),
                Text(
                  dateOfExpiry,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold, height: 0),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
