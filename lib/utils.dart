import 'package:intl/intl.dart';

class Utils {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String extractDate(DateTime dateTime) {
    return DateFormat.yMMMEd().format(dateTime);
  }

  static String extractTime(DateTime dateTime) {
    return DateFormat.Hm().format(dateTime);
  }

  static DateTime removeTime(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);
}
