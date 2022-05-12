import 'package:demo_app/model/event_data.dart';
import 'package:flutter/cupertino.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  DateTime _selectedDate = DateTime.now();

  List<Event> get events => _events;
  List<Event> get eventsOfSelectedDate => _events;
  DateTime get selectedDate => _selectedDate;

  set setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void addEvent(Event event) {
    _events.add(event);

    notifyListeners();
  }

  void appendEvent(List<Event> event) {
    _events.addAll(event);
  }

  void clearEvent() {
    _events = [];
  }

  int length() {
    if (_events.length == null) {
      return 0;
    } else {
      return _events.length;
    }
  }
}
