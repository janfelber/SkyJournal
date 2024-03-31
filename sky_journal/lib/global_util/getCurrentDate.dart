// ignore_for_file: file_names
import 'package:intl/intl.dart';

String getCurrentDate(String format) {
  DateTime currentDate = DateTime.now();
  String formattedDate = DateFormat(format).format(currentDate);
  return formattedDate;
}
