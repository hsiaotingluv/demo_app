import 'package:demo_app/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("toDateTime", () {
    test("valid date and time", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2022, 05, 18, 9, 45, 50);
      String result = Utils.toDateTime(dateTime);
      expect(result, 'Wed, May 18, 2022 09:45');
    });
    test("valid date and time in 24 hour", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2022, 05, 18, 22, 45, 50);
      String result = Utils.toDateTime(dateTime);
      expect(result, 'Wed, May 18, 2022 22:45');
    });
    test("invalid date value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2022, 02, 30, 9, 45, 50);
      String result = Utils.toDateTime(dateTime);
      expect(result, 'Wed, Mar 2, 2022 09:45');
    });
    test("large date value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(20222, 050, 180, 9, 45, 50);
      String result = Utils.toDateTime(dateTime);
      expect(result, 'Sun, Jul 30, 20226 09:45');
    });
    test("missing date value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2015);
      String result = Utils.toDateTime(dateTime);
      expect(result, 'Thu, Jan 1, 2015 00:00');
    });
    test("invalid time value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2022, 05, 18, 24, 45, 50);
      String result = Utils.toDateTime(dateTime);
      expect(result, 'Thu, May 19, 2022 00:45');
    });
    test("large time value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime =
          DateTime(2022, 05, 18, 2429012, 45127309129, 50139083);
      String result = Utils.toDateTime(dateTime);
      expect(result, 'Tue, Sep 19, 88102 06:20');
    });
    test("missing time value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2015, 1, 12, 23);
      String result = Utils.toDateTime(dateTime);
      expect(result, 'Mon, Jan 12, 2015 23:00');
    });
    test("large date and time value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2314, 0213431, 33140, 50134, 71340, 1134400);
      String result = Utils.toDateTime(dateTime);
      expect(result, 'Wed, Jun 15, 20196 14:06');
    });
  });
  group("extractDate", () {
    test("valid date value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2022, 05, 18, 9, 45, 50);
      String result = Utils.extractDate(dateTime);
      expect(result, 'Wed, May 18, 2022');
    });
    test("invalid date value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2022, 02, 30, 9, 45, 50);
      String result = Utils.extractDate(dateTime);
      expect(result, 'Wed, Mar 2, 2022');
    });
    test("large date value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(20222, 050, 180, 9, 45, 50);
      String result = Utils.extractDate(dateTime);
      expect(result, 'Sun, Jul 30, 20226');
    });
    test("missing date value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2015);
      String result = Utils.extractDate(dateTime);
      expect(result, 'Thu, Jan 1, 2015');
    });
  });
  group("extractTime", () {
    test("valid time in 24 hour", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2022, 05, 18, 22, 45, 50);
      String result = Utils.extractTime(dateTime);
      expect(result, '22:45');
    });
    test("invalid time value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2022, 05, 18, 24, 45, 50);
      String result = Utils.extractTime(dateTime);
      expect(result, '00:45');
    });
    test("large time value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime =
          DateTime(2022, 05, 18, 2429012, 45127309129, 50139083);
      String result = Utils.extractTime(dateTime);
      expect(result, '06:20');
    });
    test("missing time value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2015, 1, 12, 23);
      String result = Utils.extractTime(dateTime);
      expect(result, '23:00');
    });
  });
  group("removeTime", () {
    test("valid date and time", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2022, 05, 18, 9, 45, 50);
      DateTime result = Utils.removeTime(dateTime);
      expect(result, DateTime(2022, 05, 18));
    });
    test("invalid date value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2022, 02, 30, 9, 45, 50);
      DateTime result = Utils.removeTime(dateTime);
      expect(result, DateTime(2022, 02, 30));
    });
    test("large date value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(20222, 050, 180, 9, 45, 50);
      DateTime result = Utils.removeTime(dateTime);
      expect(result, DateTime(20222, 050, 180));
    });
    test("missing date value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2015);
      DateTime result = Utils.removeTime(dateTime);
      expect(result, DateTime(2015));
    });
    test("large time value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime =
          DateTime(2022, 05, 18, 2429012, 45127309129, 50139083);
      DateTime result = Utils.removeTime(dateTime);
      expect(result, DateTime(88102, 09, 19));
    });
    test("large date and time value", () {
      // assigns year, month, day, hour, min, seconds
      DateTime dateTime = DateTime(2314, 0213431, 33140, 50134, 71340, 1134400);
      DateTime result = Utils.removeTime(dateTime);
      expect(result, DateTime(20196, 06, 15));
    });
  });
}
