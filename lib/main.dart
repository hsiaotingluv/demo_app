import 'package:demo_app/model/event_data.dart';
import 'package:demo_app/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/widget/navigation_drawer_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// late Box<Event> box;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("first");
  await Hive.initFlutter();
  print("second");
  Hive.registerAdapter(EventAdapter());
  print("third");
  await Hive.openBox<Event>('eventBox');
  print("forth");

  // box.put(
  //   'eventData',
  //   EventData(events: events),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context, listen: false);

    final box = Hive.box<Event>('eventBox');
    provider.clearEvent();
    List<Event> events = box.values.toList();
    provider.appendEvent(events);

    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome!',
            ),
            const Text(
              'This is the home page',
            ),
          ],
        ),
      ),
    );
  }
}
