import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_session_demo/screens/profile_screen.dart';
import 'package:auth_session_demo/services/auth_service.dart';
import 'package:auth_session_demo/services/session_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('profile redirects to login when no session exists', (tester) async {
    final authService = AuthService(sessionService: SessionService());

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(authService: authService),
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login destination')),
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Login destination'), findsOneWidget);
  });

  testWidgets('profile displays and logout clears session', (tester) async {
    final authService = AuthService(sessionService: SessionService());
    await authService.login('admin', '1234');

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(authService: authService),
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login destination')),
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('User Profile'), findsOneWidget);
    await tester.tap(find.byKey(const Key('logoutButton')));
    await tester.pumpAndSettle();

    expect(find.text('Login destination'), findsOneWidget);
    expect(await authService.hasValidSession(), isFalse);
  });
}
