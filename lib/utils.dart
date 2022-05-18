import 'package:intl/intl.dart';

class Utils {
  // Returns formatted date and time in string
  // e.g. "Wed, May 18, 2022 09:45"
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  // Returns formatted date in string
  static String extractDate(DateTime dateTime) {
    return DateFormat.yMMMEd().format(dateTime);
  }

  // Returns formatted time in string
  static String extractTime(DateTime dateTime) {
    return DateFormat.Hm().format(dateTime);
  }

  // Removes time from input DateTime value
  static DateTime removeTime(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);
}
