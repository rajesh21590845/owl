import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nightowl/app.dart';

void main() {
  testWidgets('NightOwl smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(NightOwlApp()); // removed const here
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
