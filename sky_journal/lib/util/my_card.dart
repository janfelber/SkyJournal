// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sky_journal/util/transform_country.dart';
import 'package:sky_journal/util/transform_nationality.dart';

class MyCard extends StatelessWidget {
  final String name;
  final String country;
  final String sex;
  final String weight;
  final String height;
  final String hairColor;
  final String eyeColor;
  final int expiryMonth;
  final int expiryYear;
  final color;

  const MyCard(
      {Key? key,
      required this.name,
      required this.country,
      required this.sex,
      required this.weight,
      required this.height,
      required this.hairColor,
      required this.eyeColor,
      required this.expiryMonth,
      required this.expiryYear,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        width: 300,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
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

// Row(
//   children: [
    // Column(
    //   children: [
    //     Text('Sex',
    //         style:
    //             TextStyle(color: Colors.white, fontSize: 10)),
    //     Row(
    //       children: [
    //         Text(
    //           sex,
    //           style:
    //               TextStyle(color: Colors.white, fontSize: 10),
    //         ),
    //       ],
    //     ),
    //   ],
    // ),
//     SizedBox(width: 8),
//     Column(
//       children: [
//         Text('WEIGHT',
//             style:
//                 TextStyle(color: Colors.white, fontSize: 10)),
//         Row(
//           children: [
//             Text(
//               weight,
//               style:
//                   TextStyle(color: Colors.white, fontSize: 10),
//             ),
//           ],
//         ),
//       ],
//     ),
//     SizedBox(width: 8),
//     Column(
//       children: [
//         Text('HEIGHT',
//             style: TextStyle(color: Colors.white, fontSize: 8)),
//         Row(
//           children: [
//             Text(
//               height,
//               style:
//                   TextStyle(color: Colors.white, fontSize: 8),
//             ),
//           ],
//         ),
//       ],
//     ),
//     SizedBox(width: 8),
//     Column(
//       children: [
//         Text('HAIR COLOR',
//             style: TextStyle(color: Colors.white, fontSize: 8)),
//         Row(
//           children: [
//             Text(
//               hairColor,
//               style:
//                   TextStyle(color: Colors.white, fontSize: 8),
//             ),
//           ],
//         ),
//       ],
//     ),
//     SizedBox(width: 8),
//     Column(
//       children: [
//         Text('EYE COLOR',
//             style: TextStyle(color: Colors.white, fontSize: 8)),
//         Row(
//           children: [
//             Text(
//               eyeColor,
//               style:
//                   TextStyle(color: Colors.white, fontSize: 8),
//             ),
//           ],
//         ),
//       ],
//     ),
//   ],
// )
