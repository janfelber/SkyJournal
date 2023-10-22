// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sky_journal/components/my_button.dart';
import 'package:sky_journal/components/my_textfield.dart';
import 'package:sky_journal/database/firestore.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController _certifaceteNumber = TextEditingController();

  final TextEditingController _dateOfIssue = TextEditingController();

  final TextEditingController _dateOfExpiry = TextEditingController();

  final TextEditingController _nationality = TextEditingController();

  final TextEditingController _dateOfBirth = TextEditingController();

  final TextEditingController _height = TextEditingController();

  final TextEditingController _weight = TextEditingController();

  final TextEditingController _hair = TextEditingController();

  final TextEditingController _eyes = TextEditingController();

  final TextEditingController _sex = TextEditingController();

  void AddCardToDatabase() {
    if (_certifaceteNumber.text.isNotEmpty &&
        _dateOfIssue.text.isNotEmpty &&
        _dateOfExpiry.text.isNotEmpty &&
        _nationality.text.isNotEmpty &&
        _dateOfBirth.text.isNotEmpty &&
        _height.text.isNotEmpty &&
        _weight.text.isNotEmpty &&
        _hair.text.isNotEmpty &&
        _eyes.text.isNotEmpty &&
        _sex.text.isNotEmpty) {
      String certificateNumber = _certifaceteNumber.text;
      String dateOfIssue = _dateOfIssue.text;
      String dateOfExpiry = _dateOfExpiry.text;
      String nationality = _nationality.text;
      String dateOfBirth = _dateOfBirth.text;
      String height = _height.text;
      String weight = _weight.text;
      String hair = _hair.text;
      String eyes = _eyes.text;
      String sex = _sex.text;
      database.addLicenseCard(
        nationality,
        dateOfBirth,
        certificateNumber,
        dateOfIssue,
        dateOfExpiry,
        sex,
        height,
        weight,
        hair,
        eyes,
      );
    }

    _certifaceteNumber.clear();
    _dateOfIssue.clear();
    _dateOfExpiry.clear();
    _nationality.clear();
    _dateOfBirth.clear();
    _height.clear();
    _weight.clear();
    _hair.clear();
    _eyes.clear();
    _sex.clear();

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _certifaceteNumber.dispose();
    _dateOfIssue.dispose();
    _dateOfExpiry.dispose();
    _nationality.dispose();
    _dateOfBirth.dispose();
    _height.dispose();
    _weight.dispose();
    _hair.dispose();
    _eyes.dispose();
    _sex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Column(
          children: [
            MyTextField(
              controller: _certifaceteNumber,
              hintText: 'Certificate Number',
              obscureText: false,
              enabled: true,
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: _dateOfIssue,
              hintText: 'Date of Issue',
              obscureText: false,
              enabled: true,
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: _dateOfExpiry,
              hintText: 'Date of Expiry',
              obscureText: false,
              enabled: true,
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: _sex,
              hintText: 'Sex',
              obscureText: false,
              enabled: true,
            ),
            MyTextField(
              controller: _nationality,
              hintText: 'Nationality',
              obscureText: false,
              enabled: true,
            ),
            MyTextField(
              controller: _dateOfBirth,
              hintText: 'Date of Birth',
              obscureText: false,
              enabled: true,
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: _height,
              hintText: 'Height',
              obscureText: false,
              enabled: true,
            ),
            MyTextField(
              controller: _weight,
              hintText: 'Weight',
              obscureText: false,
              enabled: true,
            ),
            MyTextField(
              controller: _hair,
              hintText: 'Hair Color',
              obscureText: false,
              enabled: true,
            ),
            MyTextField(
              controller: _eyes,
              hintText: 'Eyes Color',
              obscureText: false,
              enabled: true,
            ),
            // add button
            MyButton(text: 'Add Card', onTap: AddCardToDatabase)
          ],
        )));
  }
}
