// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sky_journal/module/flight_module/flights_page.dart';
import 'package:sky_journal/module/settings_module/settings_page.dart';
import 'package:sky_journal/module/stats_module/stats_page.dart';
import 'module/wallet_module/wallet_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

  final List<Widget> _pages = [Wallet(), Flights(), Stats(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: const Color(0xFF01366A),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
              backgroundColor: Color(0xFF01366A),
              color: Colors.white,
              activeColor: Colors.orange,
              gap: 8,
              selectedIndex: _selectedIndex,
              onTabChange: _navigateBottomBar,
              padding: EdgeInsets.all(16),
              tabs: const [
                GButton(
                  icon: Icons.wallet,
                  text: 'Cards',
                ),
                GButton(
                  icon: Icons.home,
                  text: 'Flights',
                ),
                GButton(
                  icon: Icons.stacked_bar_chart,
                  text: 'Stats',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                )
              ]),
        ),
      ),
    );
  }
}
