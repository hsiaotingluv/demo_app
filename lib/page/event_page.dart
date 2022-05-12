import 'package:demo_app/main.dart';
import 'package:demo_app/model/event_data.dart';
import 'package:demo_app/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/model/event.dart';
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
  late DateTime fromDate;
  late DateTime toDate;
  bool isWholeDay = false;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = widget.selectedDay;
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
                  // title
                  TextFormField(
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Add Title',
                    ),
                    onFieldSubmitted: (_) => saveForm(),
                    validator: (title) => title != null && title.isEmpty
                        ? 'Title cannot be empty'
                        : null,
                    controller: titleController,
                  ),
                  const SizedBox(height: 12),
                  buildFromAndTo(),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text("Whole Day"),
                    value: isWholeDay,
                    onChanged: (_) {
                      setState(() {
                        isWholeDay = !isWholeDay;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  // save button
                  FloatingActionButton.extended(
                    onPressed: saveForm,
                    label: const Text("Save"),
                  ),
                ],
              ),
            )),
      );

  // event ending date and time
  Widget buildFromAndTo() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('FROM', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropDownField(
                text: Utils.extractDate(fromDate),
                onClicked: () => pickFromDateTime(isDate: true),
              ),
            ),
            if (!isWholeDay)
              Expanded(
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
            Expanded(
              flex: 2,
              child: buildDropDownField(
                text: Utils.extractDate(toDate),
                onClicked: () => pickToDateTime(isDate: true),
              ),
            ),
            if (!isWholeDay)
              Expanded(
                child: buildDropDownField(
                  text: Utils.extractTime(toDate),
                  onClicked: () => pickToDateTime(isDate: false),
                ),
              ),
          ],
        ),
      ]);

  // drop down option for date and time selection
  Widget buildDropDownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  // set the event starting date and time
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

  // set the event ending date and time
  Future pickToDateTime({required bool isDate}) async {
    final date = await pickDateTime(
      toDate,
      isDate: isDate,
      firstDate: isDate ? fromDate : null,
    );
    if (date == null) return;

    setState(() => toDate = date);
  }

  // flutter date and time picker
  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool isDate,
    DateTime? firstDate,
  }) async {
    // pick a date
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
      // pick a time
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

      print("here");

      final provider = Provider.of<EventProvider>(context, listen: false);
      // final int key = provider.length();
      final int key = 1;
      provider.addEvent(event);
      print('$key hello');

      // final eventBox = Hive.box<Event>('eventBox');

      final box = Hive.box<Event>('eventBox');
      await box.put(key.toString(), event);
      // await eventBox.put(
      //   'eventData',
      //   EventData(event: event),
      // );
      print("Success!");

      Navigator.of(context).pop();
    }
  }
}
