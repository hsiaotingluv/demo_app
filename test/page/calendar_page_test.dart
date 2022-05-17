import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Floating Action Button control test', (tester) async {
    bool isPress = false;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: FloatingActionButton(
            onPressed: () {
              isPress = true;
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );

    expect(isPress, false);
    await tester.tap(find.byType(Icon));
    expect(isPress, true);
  });

  testWidgets('Floating Action Button tooltip', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: 'Add Event',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Icon));
    expect(find.byTooltip('Add Event'), findsOneWidget);
  });
}
