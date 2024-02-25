// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:sky_journal/theme/color_theme.dart';

import '../../../components/push_to_new_page.dart';
import '../add_license_card_page.dart';
import '../doctors appoinments/add_appoinment_page.dart';

class WalletPopUpMenu extends StatelessWidget {
  const WalletPopUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.add, color: Primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: PopUp,
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: Text('Add Licese Card', style: TextStyle(color: textColor)),
            value: 1,
          ),
          PopupMenuItem(
            child: Text('Add Doctor Appointment',
                style: TextStyle(color: textColor)),
            value: 2,
          )
        ];
      },
      onSelected: (id) {
        if (id == 1) {
          pushToNewPage(context, AddLicenseCard());
        }
        if (id == 2) {
          pushToNewPage(context, AddDoctorAppointment());
        }
      },
    );
  }
}
