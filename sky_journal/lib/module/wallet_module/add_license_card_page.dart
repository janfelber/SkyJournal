// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/global_widgets/my_button.dart';
import 'package:sky_journal/global_widgets/my_textfield.dart';
import 'package:sky_journal/database/firestore.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../global_widgets/my_card.dart';
import '../../theme/color_theme.dart';

class AddLicenseCard extends StatefulWidget {
  final Function? onLicenseCardAdded;
  const AddLicenseCard({Key? key, this.onLicenseCardAdded}) : super(key: key);

  @override
  State<AddLicenseCard> createState() => _AddLicenseCardState();
}

class _AddLicenseCardState extends State<AddLicenseCard> {
  DateTime? dateOfExpiry;

  DateTime? dateOfBirth;

  String? nameOfUser;

  String? selectCountry;

  final country = [
    'Slovak Republic',
    'Czech Republic',
    'Germany',
    'France',
    'Italy',
    'Spain',
    'Ukraine',
    'Poland',
  ];

  String? selectedGender;

  final gender = ['Male', 'Female'];

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

  final StreamController<String> _nameController =
      StreamController<String>.broadcast();

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

  final StreamController<String> _dateOfExpiryController =
      StreamController<String>.broadcast();

  final StreamController<String> _nationalityController =
      StreamController<String>.broadcast();

  Future getCurrentUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String email = user.email!;

      // get user name from firestore by email
      QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore
          .instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        String userName = userQuery.docs.first.data()['first name'];
        setState(() {
          nameOfUser = userName; //there we rewrite nameOfUser
        });
      } else {
        print('User does not exist in the database');
      }
    } else {
      print('User is currently signed out');
    }
  }

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

      if (widget.onLicenseCardAdded != null) {
        widget.onLicenseCardAdded!();
      }
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
    _nationalityController.close();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserName();
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
    _dateOfExpiry.addListener(() {
      _dateOfExpiryController.sink.add(_dateOfExpiry.text);
    });
    _nationality.addListener(() {
      _nationalityController.sink.add(_nationality.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
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
                  stream: _nameController.stream,
                  initialData: '',
                  builder: (context, nameSnapshot) {
                    return StreamBuilder<String>(
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
                              builder: (context, heightSnapshot) {
                                return StreamBuilder(
                                  stream: _hairController.stream,
                                  initialData: '',
                                  builder: (context, hairSnapshot) {
                                    return StreamBuilder(
                                      stream: _eyeController.stream,
                                      initialData: '',
                                      builder: (context, eyeSnapshot) {
                                        return StreamBuilder(
                                          stream: _certificateNumberController
                                              .stream,
                                          initialData: '',
                                          builder: (context,
                                              certificationNumberSnapshot) {
                                            return StreamBuilder(
                                              stream: _dateOfExpiryController
                                                  .stream,
                                              initialData: '',
                                              builder: (context,
                                                  dateOfExpirySnapshot) {
                                                return StreamBuilder(
                                                  stream: _nationalityController
                                                      .stream, // Přidáno
                                                  initialData: '', // Přidáno
                                                  builder: (context,
                                                      nationalitySnapshot) {
                                                    return MyCard(
                                                      name: '$nameOfUser',
                                                      country:
                                                          nationalitySnapshot
                                                                  .data ??
                                                              '',
                                                      sex: sexSnapshot.data ??
                                                          '',
                                                      weight:
                                                          weightSnapshot.data ??
                                                              '',
                                                      height:
                                                          heightSnapshot.data ??
                                                              '',
                                                      hairColor:
                                                          hairSnapshot.data ??
                                                              '',
                                                      eyeColor:
                                                          eyeSnapshot.data ??
                                                              '',
                                                      colorCard: Colors.black12,
                                                      dateOfBirthDay: '',
                                                      dateOfExpiry:
                                                          dateOfExpirySnapshot
                                                                  .data ??
                                                              '',
                                                      certificationNumber:
                                                          certificationNumberSnapshot
                                                                  .data ??
                                                              '',
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
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
                        maxLength: 7,
                        numericInput: true,
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
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor:
                                  PopUp, // Prispôsobte farbu podľa svojich potrieb
                              title: Text(
                                "Departure Date",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              content: Container(
                                height: 410,
                                width: 300,
                                child: TableCalendar(
                                  selectedDayPredicate: (day) => isSameDay(
                                      dateOfExpiry ?? DateTime.now(), day),
                                  headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                    titleTextStyle:
                                        TextStyle(color: Colors.white),
                                    leftChevronIcon: Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                    ),
                                    rightChevronIcon: Icon(
                                      Icons.chevron_right,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDaySelected: (selectedDay, focusedDay) {
                                    if (selectedDay != null) {
                                      setState(() {
                                        dateOfExpiry = selectedDay;
                                        _dateOfExpiry.text =
                                            DateFormat('dd.M.yyyy')
                                                .format(dateOfExpiry!);
                                      });
                                      Navigator.pop(context);
                                    }
                                  },
                                  calendarStyle: CalendarStyle(
                                    defaultTextStyle:
                                        TextStyle(color: Colors.white),
                                    holidayTextStyle:
                                        TextStyle(color: Colors.white),
                                    weekNumberTextStyle:
                                        TextStyle(color: Colors.white),
                                    weekendTextStyle:
                                        TextStyle(color: Colors.white),
                                    selectedTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    todayTextStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    todayDecoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    selectedDecoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  focusedDay: dateOfExpiry ?? DateTime.now(),
                                  firstDay: DateTime(2000),
                                  lastDay: DateTime(2050),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.025),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width *
                              0.02, // Adjust the horizontal padding
                          vertical: screenSize.height *
                              0.01, // Adjust the vertical padding
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenSize.width *
                              0.03), // Úprava poloměru zaoblení
                          border: Border.all(
                              color: Colors.grey[700]!), // Barva ohraničení
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Text(
                              'Select Gender',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: selectedGender,
                            dropdownColor: PopUp,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            iconSize: screenSize.width * 0.06,
                            items: gender.map(buildMenuItem).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                                _sex.text = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.025),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width *
                              0.02, // Adjust the horizontal padding
                          vertical: screenSize.height *
                              0.01, // Adjust the vertical padding
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenSize.width *
                              0.03), // Úprava poloměru zaoblení
                          border: Border.all(
                              color: Colors.grey[700]!), // Barva ohraničení
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Text(
                              'Select Nation',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: selectCountry,
                            dropdownColor: PopUp,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            iconSize: screenSize.width * 0.06,
                            items: country.map(buildMenuItem).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectCountry = value;
                                _nationality.text = value!;
                              });
                            },
                          ),
                        ),
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
                        numericInput: true,
                        maxLength: 3,
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
                        numericInput: true,
                        maxLength: 3,
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

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Row(
          children: [
            Text(
              item,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
}
