// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sky_journal/global_widgets/cutom_appbar.dart';
import 'package:sky_journal/theme/color_theme.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  String appVersion = '';

  // Fetch the app version by using the package_info_plus package
  Future<void> fetchPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    setState(() {
      appVersion = version;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Surface,
        appBar: CustomAppBar(title: 'About App'),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mobile app for recording your flights',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('App Version: $appVersion',
                style: TextStyle(color: Colors.white)),
          ],
        )));
  }
}
