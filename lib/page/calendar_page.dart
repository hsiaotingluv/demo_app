import 'package:demo_app/provider/event_provider.dart';
import 'package:demo_app/widget/tasks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_app/page/event_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:demo_app/model/event_data_source.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _dayTimelineController = CalendarController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: SfCalendar(
              view: CalendarView.month,
              // Populate data to mark calendar with events visible as dots
              dataSource: EventDataSource(provider.events),
              initialSelectedDate: DateTime.now(),
              cellBorderColor: Colors.transparent,
              onTap: (CalendarTapDetails details) {
                // View events of a selected date
                provider.setDate = details.date!;
                _dayTimelineController.displayDate = details.date!;
              },
            ),
          ),
          const SizedBox(height: 12.0),
          Expanded(child: Tasks(_dayTimelineController)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(selectedDay: provider.selectedDate),
          ),
        ),
        label: const Text("Add Event"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
