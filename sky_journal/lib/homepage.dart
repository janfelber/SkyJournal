// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sky_journal/module/flight_module/flights_page.dart';
import 'package:sky_journal/module/settings_module/settings_page.dart';
import 'package:sky_journal/module/stats_module/stats_page.dart';
import 'module/wallet_module/wallet_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'theme/color_theme.dart';

class HomePage extends StatefulWidget {
  final String? userName;
  const HomePage({Key? key, this.userName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Wallet(),
      Flights(userName: widget.userName),
      Stats(),
      Settings()
    ];
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Surface,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
              backgroundColor: Surface,
              activeColor: Yellow,
              gap: 8,
              selectedIndex: _selectedIndex,
              onTabChange: _navigateBottomBar,
              padding: EdgeInsets.all(16),
              tabs: const [
                GButton(
                  icon: Icons.wallet,
                  text: 'Cards',
                  iconColor: Colors.white,
                ),
                GButton(
                  icon: Icons.home,
                  text: 'Flights',
                  iconColor: Colors.white,
                ),
                GButton(
                  icon: Icons.stacked_bar_chart,
                  text: 'Stats',
                  iconColor: Colors.white,
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                  iconColor: Colors.white,
                )
              ]),
        ),
      ),
    );
  }
}
