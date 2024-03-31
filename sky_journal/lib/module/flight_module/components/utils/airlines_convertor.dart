import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Get airline logo based on the airline name
Widget getAirlineLogo(String airlineName) {
  final lowercaseAirlineName = airlineName.toLowerCase();

  if (lowercaseAirlineName == 'air canada') {
    return SvgPicture.asset(
      'assets/airlines/Air_Canada.svg',
      height: 60,
      width: 60,
    );
  } else if (lowercaseAirlineName == 'british airways') {
    return SvgPicture.asset(
      'assets/airlines/British.svg',
      height: 60,
      width: 100,
    );
  } else if (lowercaseAirlineName == 'emirates') {
    return SvgPicture.asset(
      'assets/airlines/Emirates.svg',
      height: 50,
    );
  } else if (lowercaseAirlineName == 'etihad airways') {
    return SvgPicture.asset(
      'assets/airlines/Etihad.svg',
      height: 55,
      width: 80,
    );
  } else if (lowercaseAirlineName == 'japan airlines') {
    return Image.asset(
      'assets/airlines/japan-airlines_logo.png',
      height: 55,
    );
  } else if (lowercaseAirlineName == 'lufthansa') {
    return SvgPicture.asset(
      'assets/airlines/Lufthansa.svg',
      height: 55,
    );
  } else if (lowercaseAirlineName == 'qatar airways') {
    return SvgPicture.asset(
      'assets/airlines/Qatar.svg',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'ryanair') {
    return Image.asset(
      'assets/airlines/ryanair_logo.png',
      height: 55,
    );
  } else if (lowercaseAirlineName == 'tus airways') {
    return Image.asset(
      'assets/airlines/tus-airways_logo.png',
      height: 55,
    );
  } else if (lowercaseAirlineName == 'wizz air') {
    return SvgPicture.asset(
      'assets/airlines/Wizz_Air_UK.svg',
      height: 50,
    );
  } else if (lowercaseAirlineName == 'private') {
    return Image.asset(
      'lib/icons/small-plane.png',
      height: 70,
    );
  } else {
    // If there is an unknown airline, we will return no logo
    return Image.asset(
      'assets/airlines/no_logo.png',
      height: 24,
    );
  }
}
