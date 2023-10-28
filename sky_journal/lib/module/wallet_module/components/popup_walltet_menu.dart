// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:sky_journal/theme/color_theme.dart';

import '../../../components/push_to_new_page.dart';
import '../add_insurance_card_page.dart';
import '../add_license_card_page.dart';

class WalletPopUpMenu extends StatelessWidget {
  const WalletPopUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.add_card, color: Primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: PopUp,
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: Text('Licese Card', style: TextStyle(color: textColor)),
            value: 1,
          ),
          PopupMenuItem(
            child: Text('Insurance Card', style: TextStyle(color: textColor)),
            value: 2,
          )
        ];
      },
      onSelected: (id) {
        if (id == 1) {
          pushToNewPage(context, AddLicenseCard());
        }
        if (id == 2) {
          pushToNewPage(context, AddInsuranceCard());
          print(id);
        }
      },
    );
  }
}
