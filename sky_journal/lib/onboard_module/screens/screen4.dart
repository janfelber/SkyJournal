import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Screen4 extends StatefulWidget {
  const Screen4({Key? key}) : super(key: key);

  @override
  _Screen4State createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Ready to navigate the skies? ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 10), // Add space above the Lottie animation
            Lottie.asset('assets/flight_animation.json', height: 350),
            SizedBox(height: 20), // Add space below the Lottie animation
            Text('Hop into our app and chart your course!'),
          ],
        ),
      ),
    );
  }
}
