import 'package:flutter_test/flutter_test.dart';
import 'package:simple_product_dashboard/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Dashboard opens and navigates to product grid', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Hello, User 👋'), findsOneWidget);
    await tester.tap(find.text('Xem danh sách sản phẩm'));
    await tester.pumpAndSettle();
    expect(find.text('Product catalog'), findsOneWidget);
    expect(find.text('Product #0'), findsOneWidget);
  });
}
