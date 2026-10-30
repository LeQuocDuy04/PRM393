import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_session_demo/main.dart';
import 'package:auth_session_demo/services/auth_service.dart';
import 'package:auth_session_demo/services/session_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows login form and validation errors', (tester) async {
    final authService = AuthService(sessionService: SessionService());

    await tester.pumpWidget(
      AuthSessionDemoApp(
        authService: authService,
        initialLoggedIn: false,
      ),
    );

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byKey(const Key('usernameField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);

    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();

    expect(find.text('Please enter username'), findsOneWidget);
    expect(
      find.text('Password must contain at least 4 characters'),
      findsOneWidget,
    );
  });

  testWidgets('successful login navigates to dashboard', (tester) async {
    final authService = AuthService(sessionService: SessionService());

    await tester.pumpWidget(
      AuthSessionDemoApp(
        authService: authService,
        initialLoggedIn: false,
      ),
    );

    await tester.enterText(find.byKey(const Key('usernameField')), 'admin');
    await tester.enterText(find.byKey(const Key('passwordField')), '1234');
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Dashboard'), findsOneWidget);
    expect(await authService.hasValidSession(), isTrue);
  });
}
