import 'package:demo_app/model/event_data.dart';
import 'package:demo_app/model/event_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // testWidgets('event data source ...', (tester) async {
  //   // TODO: Implement test
  // });

  late EventDataSource sut; // system under test
  late Event event1;
  late Event event2;
  late List<Event> events;

  setUp(() {
    event1 = Event(
      title: "Test event 1",
      description: 'Description',
      from: DateTime.now(),
      to: DateTime.now(),
      backgroundColor: Colors.lightBlue.value,
      isAllDay: true,
    );
    event2 = Event(
      title: "Test event 2",
      description: 'Description',
      from: DateTime.now(),
      to: DateTime.now(),
      backgroundColor: Colors.lightBlue.value,
      isAllDay: true,
    );
    events = [event1, event2];
    sut = EventDataSource(events);
  });

  group("getEvent by index", () {
    test("given list of one event", () {
      expect(sut.getEvent(0), event1);
    });

    test("given list of more than one events", () {
      expect(sut.getEvent(1), event2);
    });
  });

  group("getStartTime by index", () {
    test("given list of one event", () {
      expect(sut.getStartTime(0), event1.from);
    });

    test("given list of more than one events", () {
      expect(sut.getStartTime(1), event2.from);
    });
  });

  group("getEndTime by index", () {
    test("given list of one event", () {
      expect(sut.getEndTime(0), event1.to);
    });

    test("given list of more than one events", () {
      expect(sut.getEndTime(1), event2.to);
    });
  });

  group("getSubject by index", () {
    test("given list of one event", () {
      expect(sut.getSubject(0), event1.title);
    });

    test("given list of more than one events", () {
      expect(sut.getSubject(1), event2.title);
    });
  });

  group("getColor by index", () {
    test("given list of one event", () {
      expect(sut.getColor(0), Color(event1.backgroundColor));
    });

    test("given list of more than one events", () {
      expect(sut.getColor(1), Color(event2.backgroundColor));
    });
  });

  group("isAllDay by index", () {
    test("given list of one event", () {
      expect(sut.isAllDay(0), event1.isAllDay);
    });

    test("given list of more than one events", () {
      expect(sut.isAllDay(1), event2.isAllDay);
    });
  });
}
