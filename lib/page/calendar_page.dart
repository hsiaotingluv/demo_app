import 'package:demo_app/provider/event_provider.dart';
import 'package:demo_app/widget/tasks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_app/page/event_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:demo_app/model/event_data_source.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SfCalendar(
            view: CalendarView.month,
            dataSource: EventDataSource(events),
            initialSelectedDate: DateTime.now(),
            cellBorderColor: Colors.transparent,
            onTap: (details) {
              final provider =
                  Provider.of<EventProvider>(context, listen: false);
              provider.setDate(details.date!);
              showModalBottomSheet(
                context: context,
                builder: (context) => Tasks(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(selectedDay: DateTime.now()),
          ),
        ),
        label: Text("Add Event"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
