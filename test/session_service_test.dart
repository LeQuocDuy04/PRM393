import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_session_demo/services/session_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('SessionService', () {
    test('saves and reads token', () async {
      final service = SessionService();
      await service.saveToken('mock_token_admin');

      expect(await service.readToken(), 'mock_token_admin');
      expect(await service.hasToken(), isTrue);
    });

    test('returns null when token does not exist', () async {
      final service = SessionService();

      expect(await service.readToken(), isNull);
      expect(await service.hasToken(), isFalse);
    });

    test('clears saved token', () async {
      final service = SessionService();
      await service.saveToken('mock_token_admin');
      await service.clearToken();

      expect(await service.readToken(), isNull);
    });
  });
}
