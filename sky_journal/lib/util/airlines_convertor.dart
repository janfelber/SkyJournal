import 'package:flutter/material.dart';

Widget getAirlineLogo(String airlineName) {
  final lowercaseAirlineName = airlineName.toLowerCase();

  if (lowercaseAirlineName == 'tus airways') {
    return Image.asset(
      'assets/images/airlines/tus-airways_logo.png',
      height: 45,
    );
  } else if (lowercaseAirlineName == 'emirates airlines' ||
      lowercaseAirlineName == 'emirates') {
    return Image.asset(
      'assets/images/airlines/emirates-airlines-logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'qatar airways') {
    return Image.asset(
      'assets/images/airlines/qatar-airways_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'lufthansa') {
    return Image.asset(
      'assets/images/airlines/lufthansa_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'aegean airlines') {
    return Image.asset(
      'assets/images/airlines/aegean_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'ryanair') {
    return Image.asset(
      'assets/images/airlines/ryanair_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'easyjet') {
    return Image.asset(
      'assets/images/airlines/easyjet_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'wizz air') {
    return Image.asset(
      'assets/images/airlines/wizzair_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'blue air') {
    return Image.asset(
      'assets/images/airlines/blueair_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'air france') {
    return Image.asset(
      'assets/images/airlines/air-france_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'british airways') {
    return Image.asset(
      'assets/images/airlines/british-airways_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'turkish airlines') {
    return Image.asset(
      'assets/images/airlines/turkish-airlines_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'air canada') {
    return Image.asset(
      'assets/images/airlines/air-canada_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'air china') {
    return Image.asset(
      'assets/images/airlines/air-china_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'air india') {
    return Image.asset(
      'assets/images/airlines/air-india_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'air new zealand') {
    return Image.asset(
      'assets/images/airlines/air-newzeland_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'airasia') {
    return Image.asset(
      'assets/images/airlines/air-asia_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'japan airlines') {
    return Image.asset(
      'assets/images/airlines/japan-airlines_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'etihad airways') {
    return Image.asset(
      'assets/images/airlines/etihad-airways_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'delta airlines') {
    return Image.asset(
      'assets/images/airlines/delta-airlines_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'american airlines') {
    return Image.asset(
      'assets/images/airlines/american-airlines_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'united airlines') {
    return Image.asset(
      'assets/images/airlines/united-airlines_logo.png',
      height: 60,
    );
  } else if (lowercaseAirlineName == 'southwest airlines') {
    return Image.asset(
      'assets/images/airlines/soutwest-airlines_logo.png',
      height: 60,
    );
  } else {
    //If there will be unknown airline, we will return no logo
    return Image.asset(
      'assets/images/airlines/no_logo.png',
      height: 24,
    );
  }
}
