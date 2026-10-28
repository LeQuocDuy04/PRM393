import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slot5_combined_app/main.dart';

void main() {
  testWidgets('Slot5 app opens the Live Counter screen', (tester) async {
    await tester.pumpWidget(const Slot5App());

    expect(find.text('Live Counter Stream'), findsOneWidget);

    // Remove the app so its timer/stream service can be disposed.
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
