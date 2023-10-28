// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/global_widgets/my_button.dart';
import 'package:sky_journal/global_widgets/my_textfield.dart';
import 'package:sky_journal/database/firestore.dart';

class AddLicenseCard extends StatefulWidget {
  const AddLicenseCard({Key? key}) : super(key: key);

  @override
  State<AddLicenseCard> createState() => _AddLicenseCardState();
}

class _AddLicenseCardState extends State<AddLicenseCard> {
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

  void addCardToDatabase() {
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
        appBar: CustomAppBar(
          title: 'Add License Card',
        ),
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MyTextField(
                      controller: _certifaceteNumber,
                      hintText: 'Certificate Number',
                      obscureText: false,
                      enabled: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MyTextField(
                      controller: _dateOfIssue,
                      hintText: 'Date of Issue',
                      obscureText: false,
                      enabled: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MyTextField(
                      controller: _dateOfExpiry,
                      hintText: 'Date of Expiry',
                      obscureText: false,
                      enabled: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MyTextField(
                      controller: _sex,
                      hintText: 'Sex',
                      obscureText: false,
                      enabled: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MyTextField(
                      controller: _nationality,
                      hintText: 'Nationality',
                      obscureText: false,
                      enabled: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MyTextField(
                      controller: _dateOfBirth,
                      hintText: 'Date of Birth',
                      obscureText: false,
                      enabled: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MyTextField(
                      controller: _height,
                      hintText: 'Height',
                      obscureText: false,
                      enabled: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MyTextField(
                      controller: _weight,
                      hintText: 'Weight',
                      obscureText: false,
                      enabled: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MyTextField(
                      controller: _hair,
                      hintText: 'Hair Color',
                      obscureText: false,
                      enabled: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MyTextField(
                      controller: _eyes,
                      hintText: 'Eyes Color',
                      obscureText: false,
                      enabled: true,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // add button
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: MyButton(
                        text: 'Add Card',
                        color: Colors.orange,
                        onTap: addCardToDatabase),
                  )
                ],
              ),
            ),
          ),
        )));
  }
}
