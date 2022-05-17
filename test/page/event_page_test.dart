import 'package:demo_app/model/event_data.dart';
import 'package:demo_app/page/event_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EventPage sut;
  late Event event;
  late DateTime selectedDay;

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
  });

  group("initial values are correct", () {
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

    // test("fromDate correct", () {
    //   expect(sut.fromDate, null);
    //   expect(sut.selectedDay.day, DateTime.now().day);
    // });
  });

  testWidgets('add a valid event name', (tester) async {
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

  testWidgets('add an invalid event name', (tester) async {
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

  testWidgets('check box toggle', (tester) async {
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

  // group("saveForm", () {
  //   testWidgets('saves valid event', (tester) async {
  //   // find all widgets needed
  //   final saveButton = find.byKey(ValueKey("saveButton"));

  //   // execute the actual test
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: EventPage(selectedDay: selectedDay),
  //     ),
  //   );

  //   await tester.tap(saveButton);
  //   await tester.pump();

  //   // check outputs
  //   expect(, true);
  // });
  // });

  // Future<void> prepareDatePicker(
  //   Finder finder,
  //   WidgetTester tester,
  //   Future<void> Function(Future<DateTime?> date) callback,
  // ) async {
  //   await tester.pumpWidget(MaterialApp(
  //     home: EventPage(selectedDay: selectedDay),
  //   ));
  //   await tester.tap(finder);
  //   await tester.pump();
  // }

  // group('showDateTimePicker', () {
  //   testWidgets('showDatePicker dialog', (tester) async {
  //     // find all widgets needed
  //     final Finder fromDate = find.byKey(ValueKey("fromDate"));
  //     final Finder fromTime = find.byKey(ValueKey("fromTime"));
  //     // execute the actual test
  //     await prepareDatePicker(fromDate, tester, (Future<DateTime?> date) async {
  //       expect(find.text('OK'), findsNothing);
  //       expect(find.text('CANCEL'), findsNothing);
  //     });
  //     // check outputs
  //   });
  // });
}
