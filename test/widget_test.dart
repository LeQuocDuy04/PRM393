import 'package:flutter_test/flutter_test.dart';
import 'package:smart_registration_app/main.dart';

void main() {
  testWidgets('Registration form displays all required fields', (tester) async {
    await tester.pumpWidget(const SmartRegistrationApp());

    expect(find.text('Smart Registration'), findsOneWidget);
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm password'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('Empty form shows validation errors', (tester) async {
    await tester.pumpWidget(const SmartRegistrationApp());
    await tester.ensureVisible(find.byKey(const Key('registerButton')));
    await tester.tap(find.byKey(const Key('registerButton')));
    await tester.pump();

    expect(find.text('This field is required.'), findsOneWidget);
    expect(find.text('Email is required.'), findsOneWidget);
    expect(find.text('Password is required.'), findsOneWidget);
  });
}
