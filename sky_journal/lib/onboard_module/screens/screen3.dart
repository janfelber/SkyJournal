import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Screen3 extends StatefulWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Visualize flight routes on maps',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10), // Meníme výšku medzery
            Lottie.asset(
              'assets/map_animation.json',
              height: 353,
              width: 500,
            ),
            SizedBox(height: 10), // Meníme výšku medzery
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('We are using over '),
                  Text(
                    '30,000',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(' airport codes in our app!')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
