import 'package:demo_app/model/event_data.dart';
import 'package:demo_app/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  final Event? event;
  final DateTime selectedDay;

  const EventPage({
    Key? key,
    this.event,
    required this.selectedDay,
  }) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate; // Event starting date and time
  late DateTime toDate; // Event ending date and time
  bool isWholeDay = false; // Check if event is whole day

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = widget.selectedDay;
      // Set ending time to be 2hrs after the starting time by default
      toDate = widget.selectedDay.add(const Duration(hours: 2));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Event'),
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Event title
                  TextFormField(
                    key: const Key("addField"),
                    style: const TextStyle(fontSize: 24),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Add Title',
                    ),
                    onFieldSubmitted: (_) => saveForm(), // Save event
                    validator: (title) => title != null && title.isEmpty
                        ? 'Title cannot be empty'
                        : null,
                    controller: titleController,
                  ),
                  const SizedBox(height: 12),
                  // Event starting and ending date and time
                  buildFromAndTo(),
                  // Check box for whole day event
                  CheckboxListTile(
                    key: const Key("checkBox"),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("Whole Day"),
                    value: isWholeDay,
                    onChanged: (_) {
                      setState(() {
                        isWholeDay = !isWholeDay;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  // Saves button
                  FloatingActionButton.extended(
                    key: const Key("saveButton"),
                    onPressed: saveForm,
                    label: const Text("Save"),
                  ),
                ],
              ),
            )),
      );

  // Widget for selecting event starting and ending date and time
  Widget buildFromAndTo() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('FROM', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            // Sets event starting date
            Expanded(
              key: const Key("fromDate"),
              flex: 2,
              child: buildDropDownField(
                text: Utils.extractDate(fromDate),
                onClicked: () => pickFromDateTime(isDate: true),
              ),
            ),
            // Sets event starting time if event is not whole day
            // Else, if event is whole day, start time selection not visible
            if (!isWholeDay)
              Expanded(
                key: const Key("fromTime"),
                child: buildDropDownField(
                  text: Utils.extractTime(fromDate),
                  onClicked: () => pickFromDateTime(isDate: false),
                ),
              ),
          ],
        ),
        const Text('TO', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            // Set event ending date
            Expanded(
              key: const Key("toDate"),
              flex: 2,
              child: buildDropDownField(
                text: Utils.extractDate(toDate),
                onClicked: () => pickToDateTime(isDate: true),
              ),
            ),
            // Sets event ending time if event is not whole day
            // Else, if event is whole day, end time selection not visible
            if (!isWholeDay)
              Expanded(
                key: const Key("toTime"),
                child: buildDropDownField(
                  text: Utils.extractTime(toDate),
                  onClicked: () => pickToDateTime(isDate: false),
                ),
              ),
          ],
        ),
      ]);

  // Widget for drop down button
  Widget buildDropDownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  // Sets event ending date and time to be after starting date and time
  Future pickFromDateTime({required bool isDate}) async {
    final date = await pickDateTime(
      fromDate,
      isDate: isDate,
    );
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate = DateTime(
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
      );
    }

    setState(() => fromDate = date);
  }

  // Sets the event ending date and time
  Future pickToDateTime({required bool isDate}) async {
    final date = await pickDateTime(
      toDate,
      isDate: isDate,
      firstDate: isDate ? fromDate : null,
    );
    if (date == null) return;

    setState(() => toDate = date);
  }

  // Sets date and time using showDatepicker and showTimePicker
  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool isDate,
    DateTime? firstDate,
  }) async {
    // Picks a date
    if (isDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );

      if (date == null) return null;

      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );

      return date.add(time);
    } else {
      // Picks a time
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date = DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
      );

      final time = Duration(
        hours: timeOfDay.hour,
        minutes: timeOfDay.minute,
      );

      return date.add(time);
    }
  }

  // Saves event
  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final event = Event(
        title: titleController.text,
        description: 'Description',
        from: fromDate,
        to: toDate,
        backgroundColor: Colors.lightBlue.value,
        isAllDay: isWholeDay,
      );

      final provider = Provider.of<EventProvider>(context, listen: false);
      final int key = provider.length();
      provider.addEvent(event);

      // Saves event to database
      final box = Hive.box<Event>('eventBox');
      await box.put(key.toString(), event);

      Navigator.of(context).pop();
    }
  }
}
