// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sky_journal/module/flight_module/components/toast.dart';

import '../../global_widgets/my_textfield.dart';
import '../flight_module/components/dialog_calendar.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  DateTime? dateOfBirth;

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();

  Future signUp() async {
    // Check if all fields are filled
    if (_firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _dateOfBirth.text.trim().isNotEmpty) {
      // Check if password is at least 6 characters long
      if (_passwordController.text.trim().length >= 6) {
        // Check if passwords match
        if (passwordConfirmed()) {
          // Create user
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          // Add user details to firestore
          addUserDetails(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _emailController.text.trim(),
            _dateOfBirth.text.trim(),
          );
        } else {
          // Show toast if passwords do not match
          showToast(
            context,
            textToast: 'Passwords do not match!',
            colorToast: Colors.red,
            imagePath: 'lib/icons/doctor-problem.png',
          );
        }
      } else {
        // Show toast if password is too short
        showToast(
          context,
          textToast: '6 characters minimum for password',
          colorToast: Colors.red,
          imagePath: 'lib/icons/doctor-problem.png',
        );
      }
    } else {
      // Show toast if any field is empty
      showToast(
        context,
        textToast: 'Please fill in all fields!',
        colorToast: Colors.red,
        imagePath: 'lib/icons/doctor-problem.png',
      );
    }
  }

  Future addUserDetails(
    String firstName,
    String lastName,
    String email,
    String dateOfBirth,
  ) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'date of birth': dateOfBirth,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Hello again!
                Text(
                  'Hello There',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Register below with your details!',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),

                //fist name textfield
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                  ),
                  child: TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'First Name',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                //last name textfield
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                  ),
                  child: TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Last Name',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: MyTextField(
                    controller: _dateOfBirth,
                    hintText: 'Date of Birth',
                    hintTextStyle:
                        TextStyle(color: Colors.black.withOpacity(0.6)),
                    obscureText: false,
                    enabled: true,
                    readOnly: true,
                    textStyle: TextStyle(color: Colors.black),
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    backgroundColor: Colors.grey[200],
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => MyDialogCalendar(
                              backgroundColor: Colors.white,
                              titleCalendarColor: Colors.black,
                              leftChevronIconColor: Colors.black,
                              rightChevronIconColor: Colors.black,
                              defaultTextStyleColor: Colors.black,
                              weekNumberTextStyle: Colors.black,
                              weekendTextStyle: Colors.black,
                              holidayTextStyleColor: Colors.black,
                              dialogTextColor: Colors.black,
                              selectedDate: dateOfBirth,
                              dialogText: 'Date of Birth',
                              onDateSelected: (date) {
                                setState(() {
                                  dateOfBirth = date;
                                  _dateOfBirth.text =
                                      DateFormat('dd.MM.yyyy').format(date);
                                });
                              }));
                    },
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                //email textfield
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                //password textfield

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                  ),
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                //confirm password textfield
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                  ),
                  child: TextField(
                    obscureText: true,
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Confirm Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                //sign up button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 25,
                ),

                //don't have an account? register button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "I am  a member!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text(
                        " Login now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
