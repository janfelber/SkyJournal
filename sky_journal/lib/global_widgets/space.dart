import 'package:flutter/material.dart';

class Space extends StatelessWidget {
  final double height;
  final double width;

  const Space.Y(double y, {Key? key})
      : height = y,
        width = 0, super(key: key);

  const Space.X(double x, {Key? key})
      : width = x,
        height = 0, super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }
}