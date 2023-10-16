import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sky_journal/pages/view_map.dart';
import 'package:sky_journal/util/routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.MAPVIEW, page: () => ViewMap()),
  ];
}
