import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ptassistant/core/ui/app_eyebrow.dart';

void main() {
  testWidgets('AppEyebrow renders its label text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppEyebrow('READY')),
      ),
    );

    expect(find.text('READY'), findsOneWidget);
  });
}
