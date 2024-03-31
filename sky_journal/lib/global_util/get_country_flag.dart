//from country get flag from country_icons package

import 'package:flutter_svg/svg.dart';

//get country flag based on country name
SvgPicture? getCountryFlag(String country) {
  switch (country) {
    case 'Slovak Republic':
      return SvgPicture.asset(
        'icons/flags/svg/sk.svg',
        package: 'country_icons',
        width: 20,
        height: 20,
      );
    case 'Czech Republic':
      return SvgPicture.asset(
        'icons/flags/svg/cz.svg',
        package: 'country_icons',
        width: 20,
        height: 20,
      );
    case 'Germany':
      return SvgPicture.asset(
        'icons/flags/svg/de.svg',
        package: 'country_icons',
        width: 20,
        height: 20,
      );
    case 'France':
      return SvgPicture.asset(
        'icons/flags/svg/fr.svg',
        package: 'country_icons',
        width: 20,
        height: 20,
      );
    case 'Italy':
      return SvgPicture.asset(
        'icons/flags/svg/it.svg',
        package: 'country_icons',
        width: 20,
        height: 20,
      );
    case 'Spain':
      return SvgPicture.asset(
        'icons/flags/svg/es.svg',
        package: 'country_icons',
        width: 20,
        height: 20,
      );
    case 'Ukraine':
      return SvgPicture.asset(
        'icons/flags/svg/ua.svg',
        package: 'country_icons',
        width: 20,
        height: 20,
      );
    case 'Poland':
      return SvgPicture.asset(
        'icons/flags/svg/pl.svg',
        package: 'country_icons',
        width: 20,
        height: 20,
      );
    default:
      return null;
  }
}
