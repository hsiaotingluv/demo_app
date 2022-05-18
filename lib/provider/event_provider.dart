import 'package:demo_app/model/event_data.dart';
import 'package:flutter/cupertino.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  DateTime _selectedDate = DateTime.now();

  List<Event> get events => _events;
  List<Event> get eventsOfSelectedDate => _events;
  DateTime get selectedDate => _selectedDate;

  // Sets selected date and time
  set setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Adds an input event to current list of events
  void addEvent(Event event) {
    _events.add(event);

    notifyListeners();
  }

  // Appends a list of input events to current list of events
  void appendEvent(List<Event> event) {
    _events.addAll(event);
  }

  // Clears the current list of events
  void clearEvent() {
    _events = [];
  }

  // Returns the length of the current list of events
  int length() {
    return _events.length;
  }
}
