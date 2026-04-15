import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Weather screen renders initial state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WeatherHomePage(autoLoad: false),
      ),
    );

    expect(
      find.text('Nhan de xem thoi tiet theo vi tri hien tai'),
      findsOneWidget,
    );
    expect(find.text('Lay du lieu thoi tiet'), findsOneWidget);
  });
}
