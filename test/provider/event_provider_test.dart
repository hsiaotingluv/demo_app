import 'package:demo_app/model/event_data.dart';
import 'package:demo_app/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EventProvider sut; // system under test
  late Event event1;
  late Event event2;
  late List<Event> expectedResult;
  late List<Event> event2List;

  setUp(() {
    sut = EventProvider();
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
    expectedResult = [event1, event2];
    event2List = [event2];
  });

  test("initial values are correct", () {
    expect(sut.events, []);
    expect(sut.selectedDate.day, DateTime.now().day);
  });

  test("addEvent successfully adds a new event to current list of events", () {
    sut.addEvent(event1);
    sut.addEvent(event2);
    expect(sut.events, expectedResult);
  });

  group("appendEvent", () {
    test("successfully append new list of events to an empty list of event",
        () {
      sut.appendEvent(expectedResult);
      expect(sut.events, expectedResult);
    });

    test("successfully append new list of events to a list of non null events",
        () {
      sut.addEvent(event1);
      sut.appendEvent(event2List);
      expect(sut.events, expectedResult);
    });

    test("successfully append repeated events to a list of non null events",
        () {
      sut.appendEvent(expectedResult);
      sut.appendEvent(expectedResult);
      expect(sut.events, [event1, event2, event1, event2]);
    });
  });

  test("clearEvent successfully deletes all existing list of events", () {
    sut.appendEvent(expectedResult);
    sut.clearEvent();
    expect(sut.events, []);
  });

  group("length", (() {
    test("successfully returns the total number of events", () {
      sut.appendEvent(expectedResult);
      expect(sut.length(), expectedResult.length);
    });

    test("successfully returns zero if existing list of events is null", () {
      expect(sut.length(), 0);
    });
  }));
}
