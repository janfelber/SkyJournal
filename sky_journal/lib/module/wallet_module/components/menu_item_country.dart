import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// DropdownMenu for countries
class DropdownMenuItemCountries {
  static DropdownMenuItem<String> buildMenuItemCountries(String item) =>
      DropdownMenuItem(
        value: item,
        child: Row(
          // Get images of flags from country_icons package
          children: [
            if (item == 'Slovak Republic') ...[
              SvgPicture.asset(
                'icons/flags/svg/sk.svg',
                package: 'country_icons',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Czech Republic') ...[
              SvgPicture.asset(
                'icons/flags/svg/cz.svg',
                package: 'country_icons',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Germany') ...[
              SvgPicture.asset(
                'icons/flags/svg/de.svg',
                package: 'country_icons',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'France') ...[
              SvgPicture.asset(
                'icons/flags/svg/fr.svg',
                package: 'country_icons',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Italy') ...[
              SvgPicture.asset(
                'icons/flags/svg/it.svg',
                package: 'country_icons',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Spain') ...[
              SvgPicture.asset(
                'icons/flags/svg/es.svg',
                package: 'country_icons',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Ukraine') ...[
              SvgPicture.asset(
                'icons/flags/svg/ua.svg',
                package: 'country_icons',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Poland') ...[
              SvgPicture.asset(
                'icons/flags/svg/pl.svg',
                package: 'country_icons',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 10),
            ],
            Text(
              item,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
}
