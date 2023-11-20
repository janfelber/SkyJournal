// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/global_widgets/my_button.dart';
import 'package:sky_journal/global_widgets/my_textfield.dart';
import 'package:sky_journal/database/firestore.dart';

import '../../global_widgets/my_card.dart';
import '../../theme/color_theme.dart';

class AddLicenseCard extends StatefulWidget {
  const AddLicenseCard({Key? key}) : super(key: key);

  @override
  State<AddLicenseCard> createState() => _AddLicenseCardState();
}

class _AddLicenseCardState extends State<AddLicenseCard> {
  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController _certifacicateNumber = TextEditingController();

  final TextEditingController _dateOfExpiry = TextEditingController();

  final TextEditingController _nationality = TextEditingController();

  final TextEditingController _dateOfBirth = TextEditingController();

  final TextEditingController _height = TextEditingController();

  final TextEditingController _weight = TextEditingController();

  final TextEditingController _hair = TextEditingController();

  final TextEditingController _eyes = TextEditingController();

  final TextEditingController _sex = TextEditingController();

  final StreamController<String> _sexController =
      StreamController<String>.broadcast();

  final StreamController<String> _weightController =
      StreamController<String>.broadcast();

  final StreamController<String> _heightController =
      StreamController<String>.broadcast();

  final StreamController<String> _hairController =
      StreamController<String>.broadcast();

  final StreamController<String> _eyeController =
      StreamController<String>.broadcast();

  final StreamController<String> _certificateNumberController =
      StreamController<String>.broadcast();

  void addCardToDatabase() {
    if (_certifacicateNumber.text.isNotEmpty &&
        _dateOfExpiry.text.isNotEmpty &&
        _nationality.text.isNotEmpty &&
        _dateOfBirth.text.isNotEmpty &&
        _height.text.isNotEmpty &&
        _weight.text.isNotEmpty &&
        _hair.text.isNotEmpty &&
        _eyes.text.isNotEmpty &&
        _sex.text.isNotEmpty) {
      String certificateNumber = _certifacicateNumber.text;
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
        dateOfExpiry,
        sex,
        height,
        weight,
        hair,
        eyes,
      );
    }

    _certifacicateNumber.clear();
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
    super.dispose();
    _certifacicateNumber.dispose();
    _dateOfExpiry.dispose();
    _nationality.dispose();
    _dateOfBirth.dispose();
    _height.dispose();
    _weight.dispose();
    _hair.dispose();
    _eyes.dispose();
    _sexController.close();
    _weightController.close();
    _heightController.close();
    _hairController.close();
    _eyeController.close();
    _certificateNumberController.close();
    _sex.dispose();
  }

  @override
  void initState() {
    super.initState();
    _sex.addListener(() {
      _sexController.sink.add(_sex.text);
    });
    _weight.addListener(() {
      _weightController.sink.add(_weight.text);
    });
    _height.addListener(() {
      _heightController.sink.add(_height.text);
    });
    _hair.addListener(() {
      _hairController.sink.add(_hair.text);
    });
    _eyes.addListener(() {
      _eyeController.sink.add(_eyes.text);
    });
    _certifacicateNumber.addListener(() {
      _certificateNumberController.sink.add(_certifacicateNumber.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Surface,
        appBar: CustomAppBar(
          title: 'Add License Card',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 200,
                child: StreamBuilder<String>(
                  stream: _sexController.stream,
                  initialData: '',
                  builder: (context, sexSnapshot) {
                    return StreamBuilder<String>(
                      stream: _weightController.stream,
                      initialData: '',
                      builder: (context, weightSnapshot) {
                        return StreamBuilder(
                            stream: _heightController.stream,
                            initialData: '',
                            builder: (context, heightSnapschot) {
                              return StreamBuilder(
                                  stream: _hairController.stream,
                                  initialData: '',
                                  builder: (context, hairSnapschot) {
                                    return StreamBuilder(
                                        stream: _eyeController.stream,
                                        initialData: '',
                                        builder: (context, eyeSnapshot) {
                                          return StreamBuilder(
                                              stream:
                                                  _certificateNumberController
                                                      .stream,
                                              initialData: '',
                                              builder: (context,
                                                  certificationNumberSnapshot) {
                                                return MyCard(
                                                  name: '',
                                                  country: '',
                                                  sex: sexSnapshot.data ?? '',
                                                  weight:
                                                      weightSnapshot.data ?? '',
                                                  height:
                                                      heightSnapschot.data ??
                                                          '',
                                                  hairColor:
                                                      hairSnapschot.data ?? '',
                                                  eyeColor:
                                                      eyeSnapshot.data ?? '',
                                                  colorCard: Colors.black12,
                                                  dateOfBirthDay: '12.10.2002',
                                                  dateOfExpiry: '14.6.2029',
                                                  certificationNumber:
                                                      certificationNumberSnapshot
                                                              .data ??
                                                          '',
                                                );
                                              });
                                        });
                                  });
                            });
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: MyTextField(
                        controller: _certifacicateNumber,
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
              )
            ],
          ),
        ));
  }
}
