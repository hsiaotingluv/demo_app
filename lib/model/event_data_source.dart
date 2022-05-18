import 'package:demo_app/model/event_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  // Returns the start time of event at input index
  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  // Returns the end time of event at input index
  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  // Returns the string title of event at input index
  @override
  String getSubject(int index) => getEvent(index).title;

  // Returns the color of event at input index
  @override
  Color getColor(int index) => Color(getEvent(index).backgroundColor);

  // Returns boolean true if event at input index is whole day
  // Else, return false
  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;
}
