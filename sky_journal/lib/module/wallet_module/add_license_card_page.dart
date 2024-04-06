// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/global_widgets/my_button.dart';
import 'package:sky_journal/global_widgets/my_textfield.dart';
import 'package:sky_journal/database/firestore.dart';
import 'package:sky_journal/module/flight_module/components/dialog_calendar.dart';
import 'package:sky_journal/module/wallet_module/components/menu_item_gender.dart';

import '../../global_widgets/my_card.dart';
import '../../theme/color_theme.dart';
import '../flight_module/components/toast.dart';
import 'components/menu_item_country.dart';

class AddLicenseCard extends StatefulWidget {
  final Function? onLicenseCardAdded;
  const AddLicenseCard({Key? key, this.onLicenseCardAdded}) : super(key: key);

  @override
  State<AddLicenseCard> createState() => _AddLicenseCardState();
}

class _AddLicenseCardState extends State<AddLicenseCard> {
  DateTime? dateOfExpiry;

  String? dateOfBirth;

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

  String? token;

  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController _certifacicateNumber = TextEditingController();

  final TextEditingController _dateOfExpiry = TextEditingController();

  final TextEditingController _nationality = TextEditingController();

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

  // Get date of birth from firestore
  Future getDateOfBirth() async {
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
        String birthDate = userQuery.docs.first.data()['date of birth'];
        setState(() {
          dateOfBirth = birthDate; //there we rewrite birthDate
        });
      } else {
        print('User does not exist in the database');
      }
    } else {
      print('User is currently signed out');
    }
  }

  // Get current user name from firestore
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
        String firstName = userQuery.docs.first.data()['first name'];
        String lastName = userQuery.docs.first.data()['last name'];
        setState(() {
          nameOfUser = firstName + ' ' + lastName; //there we rewrite nameOfUser
        });
      } else {
        print('User does not exist in the database');
      }
    } else {
      print('User is currently signed out');
    }
  }

  //get fcm token
  Future<void> getToken() async {
    token = await FirebaseMessaging.instance.getToken();
  }

  void addCardToDatabase() {
    // If date of expiry is before today
    if (dateOfExpiry != null) {
      if (dateOfExpiry!.isBefore(DateTime.now())) {
        showToast(
          context,
          textToast: "Date of expiry must be in the future",
          imagePath: 'lib/icons/credit-card.png',
          colorToast: Colors.red,
          textColor: Colors.white,
        );
        return;
      }
    }

    if (_certifacicateNumber.text.isNotEmpty &&
        _dateOfExpiry.text.isNotEmpty &&
        _nationality.text.isNotEmpty &&
        _height.text.isNotEmpty &&
        _weight.text.isNotEmpty &&
        _hair.text.isNotEmpty &&
        _eyes.text.isNotEmpty &&
        _sex.text.isNotEmpty) {
      String certificateNumber = _certifacicateNumber.text;
      String dateOfExpiry = _dateOfExpiry.text;
      String nationality = _nationality.text;
      String height = _height.text;
      String weight = _weight.text;
      String hair = _hair.text;
      String eyes = _eyes.text;
      String sex = _sex.text;
      database.addLicenseCard(
        nationality,
        certificateNumber,
        dateOfExpiry,
        sex,
        height,
        weight,
        hair,
        eyes,
        token!,
        false,
      );

      if (widget.onLicenseCardAdded != null) {
        widget.onLicenseCardAdded!();
      }

      _certifacicateNumber.clear();
      _dateOfExpiry.clear();
      _nationality.clear();
      _height.clear();
      _weight.clear();
      _hair.clear();
      _eyes.clear();
      _sex.clear();

      Navigator.pop(context);
    } else {
      // Show a Toast indicating that all fields must be filled
      showToast(
        context,
        textToast: "Please fill in all fields",
        imagePath: 'lib/icons/credit-card.png',
        colorToast: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();

    _certifacicateNumber.dispose();
    _dateOfExpiry.dispose();
    _nationality.dispose();
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
    getDateOfBirth();
    getToken();
    // Add listeners to the text controllers and update the stream controllers
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
              // This will dynamically update the card with the user's information
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
                                                      dateOfBirthDay:
                                                          '$dateOfBirth',
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
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 16.0),
                        hintTextStyle: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                        backgroundColor: Colors.transparent,
                        enabledBorderColor: Colors.grey[700],
                        focusedBorderColor: Colors.grey[700],
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
                        readOnly: true,
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 16.0),
                        hintTextStyle: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                        backgroundColor: Colors.transparent,
                        enabledBorderColor: Colors.grey[700],
                        focusedBorderColor: Colors.grey[700],
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => MyDialogCalendar(
                                  selectedDate: dateOfExpiry,
                                  dialogText: 'Date of Expiry',
                                  onDateSelected: (date) {
                                    setState(() {
                                      dateOfExpiry = date;
                                      _dateOfExpiry.text =
                                          DateFormat('dd.MM.yyyy').format(date);
                                    });
                                  }));
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
                          borderRadius:
                              BorderRadius.circular(screenSize.width * 0.03),
                          border: Border.all(color: Colors.grey[700]!),
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
                            items: gender
                                .map((item) => DropdownMenuItemGenders
                                    .buildMenuItemGenders(item))
                                .toList(),
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
                          borderRadius:
                              BorderRadius.circular(screenSize.width * 0.03),
                          border: Border.all(color: Colors.grey[700]!),
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
                            items: country
                                .map((item) => DropdownMenuItemCountries
                                    .buildMenuItemCountries(item))
                                .toList(),
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
                        controller: _height,
                        hintText: 'Height',
                        obscureText: false,
                        enabled: true,
                        numericInput: true,
                        maxLength: 3,
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 16.0),
                        hintTextStyle: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                        backgroundColor: Colors.transparent,
                        enabledBorderColor: Colors.grey[700],
                        focusedBorderColor: Colors.grey[700],
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
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 16.0),
                        hintTextStyle: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                        backgroundColor: Colors.transparent,
                        enabledBorderColor: Colors.grey[700],
                        focusedBorderColor: Colors.grey[700],
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
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 16.0),
                        hintTextStyle: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                        backgroundColor: Colors.transparent,
                        enabledBorderColor: Colors.grey[700],
                        focusedBorderColor: Colors.grey[700],
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
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 16.0),
                        hintTextStyle: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                        backgroundColor: Colors.transparent,
                        enabledBorderColor: Colors.grey[700],
                        focusedBorderColor: Colors.grey[700],
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
