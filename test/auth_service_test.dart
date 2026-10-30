import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_session_demo/services/auth_service.dart';
import 'package:auth_session_demo/services/session_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AuthService', () {
    late SessionService sessionService;
    late AuthService authService;

    setUp(() {
      sessionService = SessionService();
      authService = AuthService(sessionService: sessionService);
    });

    test('logs in with admin / 1234 and persists session', () async {
      expect(await authService.login('admin', '1234'), isTrue);
      expect(await authService.hasValidSession(), isTrue);
    });

    test('rejects invalid credentials and does not create session', () async {
      expect(await authService.login('admin', 'wrong'), isFalse);
      expect(await authService.hasValidSession(), isFalse);
    });

    test('logout clears session', () async {
      await authService.login('admin', '1234');
      await authService.logout();

      expect(await authService.hasValidSession(), isFalse);
    });
  });
}
