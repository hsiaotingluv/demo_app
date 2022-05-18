import 'package:demo_app/model/event_data.dart';
import 'package:demo_app/page/event_page.dart';
import 'package:demo_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  late EventPage sut;
  late Event event;
  late DateTime selectedDay;
  late DateTime fromDate;
  late DateTime toDate;

  setUp(() {
    event = Event(
      title: "Test event",
      description: 'Description',
      from: DateTime.now(),
      to: DateTime.now(),
      backgroundColor: Colors.lightBlue.value,
      isAllDay: true,
    );
    selectedDay = DateTime.now();
    sut = EventPage(
      event: event,
      selectedDay: selectedDay,
    );
    fromDate = DateTime.now();
    toDate = DateTime.now();
  });

  group("Initial values are correct", () {
    test("given event and selectedDay", () {
      expect(sut.event, event);
      expect(sut.selectedDay.day, DateTime.now().day);
    });

    test("given only selectedDay", () {
      sut = EventPage(
        selectedDay: selectedDay,
      );
      expect(sut.event, null);
      expect(sut.selectedDay.day, DateTime.now().day);
    });
  });

  group("Add Title", () {
    testWidgets('Valid event name', (tester) async {
      // find all widgets needed
      final addField = find.byKey(ValueKey("addField"));

      // execute the actual test
      await tester.pumpWidget(
        MaterialApp(
          home: EventPage(selectedDay: selectedDay),
        ),
      );
      await tester.enterText(addField, "This is the event name");
      await tester.pump();

      // check outputs
      expect(find.text("This is the event name"), findsOneWidget);
    });

    testWidgets('Invalid event name', (tester) async {
      // find all widgets needed
      final addField = find.byKey(ValueKey("addField"));

      // execute the actual test
      await tester.pumpWidget(
        MaterialApp(
          home: EventPage(selectedDay: selectedDay),
        ),
      );
      await tester.enterText(addField, "");
      await tester.pump();

      // check outputs
      expect(find.text("Title cannot be empty"), findsNothing);
    });
  });

  testWidgets('Check box toggle', (tester) async {
    // find all widgets needed
    final checkboxFinder = find.byKey(ValueKey("checkBox"));

    // execute the actual test
    await tester.pumpWidget(
      MaterialApp(
        home: EventPage(selectedDay: selectedDay),
      ),
    );

    var checkbox = tester.firstWidget(checkboxFinder) as CheckboxListTile;

    // check outputs
    expect(checkbox.value, false);

    await tester.tap(checkboxFinder);
    await tester.pump();

    // check outputs
    checkbox = tester.firstWidget(checkboxFinder) as CheckboxListTile;
    expect(checkbox.value, true);
  });

  toDate = DateTime.now().add(const Duration(hours: 2));

  testWidgets('Event page content', (tester) async {
    // find all widgets needed
    final addField = find.byKey(ValueKey("addField"));
    final checkboxFinder = find.byKey(ValueKey("checkBox"));
    final saveButton = find.byKey(ValueKey("saveButton"));

    // execute the actual test
    await tester.pumpWidget(
      MaterialApp(
        home: EventPage(selectedDay: selectedDay),
      ),
    );

    // check outputs
    expect(addField, findsOneWidget);
    expect(checkboxFinder, findsOneWidget);
    expect(saveButton, findsOneWidget);
  });

  Future<void> prepareDatePicker(
    Finder finder,
    WidgetTester tester,
    Future<void> Function(Future<DateTime?> date) callback,
  ) async {
    await tester.pumpWidget(MaterialApp(
      home: EventPage(selectedDay: selectedDay),
    ));
    await tester.tap(finder);
    await tester.pump();
  }

  group('showDateTimePicker', () {
    testWidgets('showDatePicker date content, with cancel, ok options',
        (tester) async {
      final Finder fromDate = find.byKey(ValueKey("fromDate"));

      await tester.pumpWidget(MaterialApp(
        home: EventPage(selectedDay: selectedDay),
      ));

      expect(find.text('OK'), findsNothing);
      expect(find.text('CANCEL'), findsNothing);
      expect(find.text('SELECT DATE'), findsNothing);
      expect(find.text('SELECT TIME'), findsNothing);

      await tester.tap(fromDate);
      await tester.pump();

      expect(find.text('OK'), findsOneWidget);
      expect(find.text('CANCEL'), findsOneWidget);
      expect(find.text('SELECT DATE'), findsOneWidget);
      expect(find.text('SELECT TIME'), findsNothing);

      await tester.tap(find.text('CANCEL'));
      await tester.pump();

      expect(find.text('OK'), findsNothing);
      expect(find.text('CANCEL'), findsNothing);
      expect(find.text('SELECT DATE'), findsNothing);
      expect(find.text('SELECT TIME'), findsNothing);
    });

    testWidgets('showDatePicker time content, with cancel, ok options',
        (tester) async {
      final Finder fromTime = find.byKey(ValueKey("fromTime"));

      await tester.pumpWidget(MaterialApp(
        home: EventPage(selectedDay: selectedDay),
      ));

      expect(find.text('OK'), findsNothing);
      expect(find.text('CANCEL'), findsNothing);
      expect(find.text('SELECT DATE'), findsNothing);
      expect(find.text('SELECT TIME'), findsNothing);

      await tester.tap(fromTime);
      await tester.pump();

      expect(find.text('OK'), findsOneWidget);
      expect(find.text('CANCEL'), findsOneWidget);
      expect(find.text('SELECT DATE'), findsNothing);
      expect(find.text('SELECT TIME'), findsOneWidget);

      await tester.tap(find.text('CANCEL'));
      await tester.pump();

      expect(find.text('OK'), findsNothing);
      expect(find.text('CANCEL'), findsNothing);
      expect(find.text('SELECT DATE'), findsNothing);
      expect(find.text('SELECT TIME'), findsNothing);
    });

    testWidgets('Initial date is default to selected day', (tester) async {
      final Finder fromDate = find.byKey(ValueKey("fromDate"));
      String dateString = DateFormat.MMMEd().format(selectedDay);

      await tester.pumpWidget(MaterialApp(
        home: EventPage(selectedDay: selectedDay),
      ));

      await tester.tap(fromDate);
      await tester.pump();
      expect(find.text(dateString), findsOneWidget);
    });

    testWidgets('Initial time is default to current time', (tester) async {
      final Finder fromTime = find.byKey(ValueKey("fromTime"));
      String timeString = DateFormat.Hm().format(DateTime.now());

      await tester.pumpWidget(MaterialApp(
        home: EventPage(selectedDay: selectedDay),
      ));

      await tester.tap(fromTime);
      await tester.pump();
      expect(find.text(timeString), findsOneWidget);
    });

    testWidgets('Can select a date', (tester) async {
      final Finder fromDate = find.byKey(ValueKey("fromDate"));
      String dateStringWithYear = DateFormat.yMMMEd().format(selectedDay);

      await tester.pumpWidget(MaterialApp(
        home: EventPage(selectedDay: selectedDay),
      ));

      await tester.tap(fromDate);
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pump();
      expect(find.text(dateStringWithYear), findsWidgets);
    });

    testWidgets('Can select a time', (tester) async {
      final Finder fromTime = find.byKey(ValueKey("fromTime"));
      String timeString = DateFormat.Hm().format(DateTime.now());

      await tester.pumpWidget(MaterialApp(
        home: EventPage(selectedDay: selectedDay),
      ));

      await tester.tap(fromTime);
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pump();
      expect(find.text(timeString), findsWidgets);
    });

    testWidgets('End date is same or later than start date', (tester) async {
      final Finder fromDate = find.byKey(ValueKey("fromDate"));

      await tester.pumpWidget(MaterialApp(
        home: EventPage(selectedDay: selectedDay),
      ));

      await tester.tap(fromDate);
      await tester.pump();
      await tester.tap(find.text('30'));
      await tester.pump();

      selectedDay = DateTime(selectedDay.year, selectedDay.month, 30);
      String dateString = DateFormat.MMMEd().format(selectedDay);
      String dateStringWithYear = DateFormat.yMMMEd().format(selectedDay);
      expect(find.text(dateString), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pump();
      // find exactly 2 same dates
      // toDate set to same as fromDate
      expect(find.text(dateStringWithYear), findsNWidgets(2));
    });

    testWidgets('End time is same or later than start time', (tester) async {
      final Finder fromTime = find.byKey(ValueKey("fromTime"));
      final String minute = DateFormat.m().format(selectedDay);
      await tester.pumpWidget(MaterialApp(
        home: EventPage(selectedDay: selectedDay),
      ));

      await tester.tap(fromTime);
      await tester.pump();
      await tester.tap(find.text('11'));
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(find.text('PM'));
      await tester.pump(const Duration(seconds: 2));

      final String newTime12 = '11:' + minute;
      final String newTime24 = '23:' + minute;
      expect(find.text(newTime12), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pump();
      // find exactly 2 same time
      // toTime set to same as fromTime
      expect(find.text(newTime24), findsNWidgets(2));
    });
  });
}
