// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../global_widgets/cutom_appbar.dart';
import '../../../theme/color_theme.dart';
import '../components/icon_style.dart';
import '../components/settings_group.dart';
import '../components/settings_items.dart';

class AppareancePage extends StatefulWidget {
  const AppareancePage({super.key});

  @override
  State<AppareancePage> createState() => _AppareancePageState();
}

class _AppareancePageState extends State<AppareancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Surface,
      appBar: CustomAppBar(title: 'Appareance'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Column(
                children: [
                  SettingsGroup(
                      settingsGroupTitle: 'Language',
                      settingsGroupTitleStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      items: [
                        SettingsItem(
                          title: 'Language Preference',
                          titleStyle: TextStyle(color: Colors.white),
                          subtitleStyle: TextStyle(color: Colors.white),
                          icons: CupertinoIcons.globe,
                          iconStyle: IconStyle(
                              iconsColor: Colors.white,
                              withBackground: true,
                              backgroundColor: Colors.blue),
                          onTap: () {},
                        ),
                      ]),
                  SettingsGroup(
                      settingsGroupTitle: 'Change Theme',
                      settingsGroupTitleStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      items: [
                        SettingsItem(
                          title: 'Deuteranomaly',
                          titleStyle: TextStyle(color: Colors.white),
                          subtitleStyle: TextStyle(color: Colors.white),
                          onTap: () {},
                        ),
                        SettingsItem(
                          title: 'Protanomaly',
                          titleStyle: TextStyle(color: Colors.white),
                          subtitleStyle: TextStyle(color: Colors.white),
                          onTap: () {},
                        ),
                        SettingsItem(
                          title: 'Tritanomaly',
                          titleStyle: TextStyle(color: Colors.white),
                          subtitleStyle: TextStyle(color: Colors.white),
                          onTap: () {},
                        ),
                        SettingsItem(
                          title: 'Tritanopia',
                          titleStyle: TextStyle(color: Colors.white),
                          subtitleStyle: TextStyle(color: Colors.white),
                          onTap: () {},
                        ),
                      ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
