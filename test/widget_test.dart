import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gebetsglas/widgets/common.dart';

void main() {
  testWidgets('GlassCard rendert Inhalt', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GlassCard(child: Text('Gebetsglas')),
        ),
      ),
    );

    expect(find.text('Gebetsglas'), findsOneWidget);
  });
}
