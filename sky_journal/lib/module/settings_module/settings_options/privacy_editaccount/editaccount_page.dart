// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/global_widgets/my_textfield.dart';
import 'package:sky_journal/theme/color_theme.dart';

import '../../../../database/firestore.dart';
import '../../../../global_widgets/my_button.dart';

class EdirProfilePage extends StatefulWidget {
  const EdirProfilePage({super.key});

  @override
  State<EdirProfilePage> createState() => _EdirProfilePageState();
}

class _EdirProfilePageState extends State<EdirProfilePage> {
  final FirestoreDatabase database = FirestoreDatabase();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _countryController = TextEditingController();

  void EditProfile() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Surface,
      appBar: CustomAppBar(
        title: 'Edit Profile',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
          child: Column(
            children: [
              MyTextField(
                  hintText: 'Name',
                  obscureText: false,
                  enabled: true,
                  controller: _nameController),
              SizedBox(
                height: 15,
              ),
              MyTextField(
                  hintText: 'Surname',
                  obscureText: false,
                  enabled: true,
                  controller: _surnameController),
              SizedBox(
                height: 15,
              ),
              MyTextField(
                  hintText: 'Country',
                  obscureText: false,
                  enabled: true,
                  controller: _countryController),
              SizedBox(
                height: 15,
              ),
              MyButton(
                text: 'Save',
                onTap: EditProfile,
                color: Yellow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
