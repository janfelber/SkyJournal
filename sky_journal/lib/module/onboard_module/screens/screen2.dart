import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Boost your flight experience with live stats!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 10),
            Lottie.asset(
              'assets/stats_animation.json',
              height: 362,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
