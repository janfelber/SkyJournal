// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCodeWidget extends StatefulWidget {
  const PinCodeWidget({super.key});

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> {
  String pinCode = '';
  bool isPinCodeVisible = false;

  void savePinCodeLocally(String pinCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("pin_code", pinCode);
  }

  Widget numberButton(int number) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: () {
          if (pinCode.length < 4) {
            setState(() {
              pinCode += number.toString();
            });
          }
        },
        child: Text(
          number.toString(),
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              Center(
                child: Text(
                  'Enter Your Pin',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 50,
              ),

              //pincode area
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) {
                    return Container(
                      margin: EdgeInsets.all(6.0),
                      width: isPinCodeVisible ? 50 : 16,
                      height: isPinCodeVisible ? 50 : 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: index < pinCode.length
                            ? isPinCodeVisible
                                ? Colors.green
                                : CupertinoColors.activeBlue
                            : CupertinoColors.activeBlue.withOpacity(0.1),
                      ),
                      child: isPinCodeVisible && index < pinCode.length
                          ? Center(
                              child: Text(
                                pinCode[index],
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: CupertinoColors.systemBlue),
                              ),
                            )
                          : null,
                    );
                  },
                ),
              ),

              for (var i = 0; i < 3; i++)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        3, (index) => numberButton(1 + 3 * i + index)).toList(),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: null, child: SizedBox()),
                    numberButton(0),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (pinCode.isNotEmpty) {
                              pinCode =
                                  pinCode.substring(0, pinCode.length - 1);
                            }
                          });
                        },
                        child: Icon(
                          Icons.backspace,
                          color: Colors.black,
                          size: 28,
                        ))
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    savePinCodeLocally(pinCode);
                  });
                },
                child: Text(
                  'Reset',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ]),
      ),
    );
  }
}
