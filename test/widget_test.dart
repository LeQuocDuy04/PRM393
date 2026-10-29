import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_dashboard/main.dart';

void main() {
  testWidgets('Dashboard shows summary cards and product grid', (tester) async {
    await tester.pumpWidget(const ResponsiveDashboardApp());

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Revenue'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Customers'), findsOneWidget);
    expect(find.text('Products'), findsOneWidget);
  });
}
