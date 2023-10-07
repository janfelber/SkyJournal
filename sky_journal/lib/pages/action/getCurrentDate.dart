import 'package:intl/intl.dart';

String getCurrentDate() {
  DateTime currentDate = DateTime.now();
  String formattedDate = DateFormat.yMMMMd('en_US').format(currentDate);
  return formattedDate;
}
