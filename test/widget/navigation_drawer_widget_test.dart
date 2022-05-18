import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Drawer control test', (WidgetTester tester) async {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    late BuildContext savedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            savedContext = context;
            return Scaffold(
              key: scaffoldKey,
              drawer: const Text('drawer'),
              body: Container(),
            );
          },
        ),
      ),
    );

    await tester.pump(); // no effect
    expect(find.text('drawer'), findsNothing);

    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
    await tester.pump(); // drawer should be starting to animate in
    expect(find.text('drawer'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1)); // animation done
    expect(find.text('drawer'), findsOneWidget);

    Navigator.pop(savedContext);
    await tester.pump(); // drawer should be starting to animate away
    expect(find.text('drawer'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1)); // animation done
    expect(find.text('drawer'), findsNothing);
  });

  testWidgets('Drawer menu content test', (WidgetTester tester) async {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    bool isCalendar = false;
    bool isEvent = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              key: scaffoldKey,
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    Column(children: [
                      const Text('drawer'),
                      TextButton(
                        child: const Text('Calendar'),
                        onPressed: () => isCalendar = true,
                      ),
                      TextButton(
                        child: const Text('Event'),
                        onPressed: () => isEvent = true,
                      ),
                    ])
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    // Open the drawer.
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
    await tester.pump(); // drawer should be starting to animate in
    expect(find.text('drawer'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(isCalendar, equals(false));
    expect(find.text('Event'), findsOneWidget);
    expect(isEvent, equals(false));

    // Tap the calendar button.
    await tester.ensureVisible(
      find.text('Calendar'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Calendar'));
    await tester.pump();
    expect(isCalendar, equals(true));

    // Tap the calendar button.
    await tester.ensureVisible(
      find.text('Event'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Event'));
    await tester.pump();
    expect(isEvent, equals(true));
  });

  testWidgets('Drawer navigator back button', (WidgetTester tester) async {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    bool buttonPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              key: scaffoldKey,
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    const Text('drawer'),
                    TextButton(
                      child: const Text('close'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              body: TextButton(
                child: const Text('button'),
                onPressed: () {
                  buttonPressed = true;
                },
              ),
            );
          },
        ),
      ),
    );

    // Open the drawer.
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
    await tester.pump(); // drawer should be starting to animate in
    expect(find.text('drawer'), findsOneWidget);

    // Tap the close button to pop the drawer route.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('close'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('drawer'), findsNothing);

    // Confirm that a button in the scaffold body is still clickable.
    await tester.tap(find.text('button'));
    expect(buttonPressed, equals(true));
  });
}
