// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/module/settings_module/components/settings_group.dart';
import 'package:sky_journal/module/settings_module/components/settings_items.dart';

import '../../../theme/color_theme.dart';
import '../components/icon_style.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Surface,
      appBar: CustomAppBar(title: 'Privacy'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Column(
                children: [
                  SettingsGroup(
                      settingsGroupTitle: 'Account',
                      settingsGroupTitleStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      items: [
                        SettingsItem(
                          title: 'Edit Profile',
                          titleStyle: TextStyle(color: Colors.white),
                          subtitleStyle: TextStyle(color: Colors.white),
                          onTap: () {},
                        ),
                      ]),
                  SettingsGroup(
                      settingsGroupTitle: 'Privacy and Security',
                      settingsGroupTitleStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      items: [
                        SettingsItem(
                          title: 'Biometric Lock',
                          titleStyle: TextStyle(color: Colors.white),
                          subtitleStyle: TextStyle(color: Colors.white),
                          icons: Icons.fingerprint,
                          iconStyle: IconStyle(
                              iconsColor: Colors.white,
                              withBackground: true,
                              backgroundColor: Colors.red),
                          onTap: () {},
                          trailing: Switch.adaptive(
                            value: false,
                            onChanged: (value) {},
                          ),
                        ),
                        SettingsItem(
                          title: 'Delete Account',
                          titleStyle: TextStyle(color: Colors.white),
                          subtitleStyle: TextStyle(color: Colors.white),
                          icons: CupertinoIcons.delete,
                          iconStyle: IconStyle(
                              iconsColor: Colors.white,
                              withBackground: true,
                              backgroundColor: Colors.red),
                          onTap: () {},
                        ),
                        SettingsItem(
                          title: 'Terms of Use',
                          titleStyle: TextStyle(color: Colors.white),
                          onTap: () {},
                        ),
                        SettingsItem(
                          title: 'Privacy Policy',
                          titleStyle: TextStyle(color: Colors.white),
                          onTap: () {
                            // Otevřít stránku s "Zásady ochrany osobních údajů" nebo zobrazit dokument s "Zásadami ochrany osobních údajů".
                          },
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
