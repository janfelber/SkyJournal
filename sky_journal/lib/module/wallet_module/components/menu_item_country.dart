import 'package:country_icons/country_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DropdownMenuItemCountries {
  static DropdownMenuItem<String> buildMenuItemCountries(String item) =>
      DropdownMenuItem(
        value: item,
        child: Row(
          children: [
            if (item == 'Slovak Republic') ...[
              SvgPicture.asset(
                'icons/flags/svg/sk.svg',
                package: 'country_icons',
                width: 20, // Specifikujte šířku ikony
                height: 20, // Specifikujte výšku ikony
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Czech Republic') ...[
              SvgPicture.asset(
                'icons/flags/svg/cz.svg',
                package: 'country_icons',
                width: 20, // Specifikujte šířku ikony
                height: 20, // Specifikujte výšku ikony
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Germany') ...[
              SvgPicture.asset(
                'icons/flags/svg/de.svg',
                package: 'country_icons',
                width: 20, // Specifikujte šířku ikony
                height: 20, // Specifikujte výšku ikony
              ),
              SizedBox(width: 10),
            ],
            if (item == 'France') ...[
              SvgPicture.asset(
                'icons/flags/svg/fr.svg',
                package: 'country_icons',
                width: 20, // Specifikujte šířku ikony
                height: 20, // Specifikujte výšku ikony
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Italy') ...[
              SvgPicture.asset(
                'icons/flags/svg/it.svg',
                package: 'country_icons',
                width: 20, // Specifikujte šířku ikony
                height: 20, // Specifikujte výšku ikony
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Spain') ...[
              SvgPicture.asset(
                'icons/flags/svg/es.svg',
                package: 'country_icons',
                width: 20, // Specifikujte šířku ikony
                height: 20, // Specifikujte výšku ikony
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Ukraine') ...[
              SvgPicture.asset(
                'icons/flags/svg/ua.svg',
                package: 'country_icons',
                width: 20, // Specifikujte šířku ikony
                height: 20, // Specifikujte výšku ikony
              ),
              SizedBox(width: 10),
            ],
            if (item == 'Poland') ...[
              SvgPicture.asset(
                'icons/flags/svg/pl.svg',
                package: 'country_icons',
                width: 20, // Specifikujte šířku ikony
                height: 20, // Specifikujte výšku ikony
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
