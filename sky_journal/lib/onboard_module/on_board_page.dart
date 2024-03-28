// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_journal/components/push_to_new_page.dart';
import 'package:sky_journal/onboard_module/screens/screen4.dart';
import 'package:sky_journal/onboard_module/screens/welcome_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../auth_user/auth_user.dart';
import 'screens/screen1.dart';
import 'screens/screen2.dart';
import 'screens/screen3.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  //controller to control the page view
  final PageController _controller = PageController();

  //is last page
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = (index == 4);
              });
            },
            children: [
              WelcomePage(),
              Screen1(),
              Screen2(),
              Screen3(),
              Screen4(),
            ],
          ),

          //indicator to show the current page
          Container(
            alignment: Alignment(0, 0.80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip button
                GestureDetector(
                  child: Text('Skip'),
                  onTap: () {
                    _controller.jumpToPage(4);
                  },
                ),
                //indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 5,
                ),

                //next button or get started button
                isLastPage
                    ? GestureDetector(
                        child: Text('Done'),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('showLogin', true);
                          //navigate to the home page
                          pushToNewPage(context, AuthUser());
                        })
                    : GestureDetector(
                        child: Text('Next'),
                        onTap: () {
                          //navigate to the next page
                          _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
