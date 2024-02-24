import 'package:flutter/material.dart';

Widget getAirlineLogo(String airlineName) {
  final lowercaseAirlineName = airlineName.toLowerCase();

  if (lowercaseAirlineName == 'air canada') {
    return Image.asset(
      'assets/airlines/air-canada_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'air france') {
    return Image.asset(
      'assets/airlines/air-france_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'british airways') {
    return Image.asset(
      'assets/airlines/british-airways_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'easyjet') {
    return Image.asset(
      'assets/airlines/easyjet_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'emirates') {
    return Image.asset(
      'assets/airlines/emirates-airlines-logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'etihad airways') {
    return Image.asset(
      'assets/airlines/etihad-airways_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'japan airlines') {
    return Image.asset(
      'assets/airlines/japan-airlines_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'lufthansa') {
    return Image.asset(
      'assets/airlines/lufthansa_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'qatar airways') {
    return Image.asset(
      'assets/airlines/qatar-airways_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'ryanair') {
    return Image.asset(
      'assets/airlines/ryanair_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'tus airways') {
    return Image.asset(
      'assets/airlines/tus-airways_logo.png',
      height: 45,
    );
  } else if (lowercaseAirlineName == 'wizz air') {
    return Image.asset(
      'assets/airlines/wizz-air_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'personal') {
    return Image.asset(
      'assets/airlines/private-jet_logo.png',
      height: 60,
    );
  } else {
    // If there is an unknown airline, we will return no logo
    return Image.asset(
      'assets/airlines/no_logo.png',
      height: 24,
    );
  }
}
