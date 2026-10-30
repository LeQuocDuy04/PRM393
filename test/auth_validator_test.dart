import 'package:flutter_test/flutter_test.dart';
import 'package:auth_session_demo/utils/auth_validator.dart';

void main() {
  group('AuthValidator', () {
    test('rejects empty username', () {
      expect(AuthValidator.validateUsername(''), 'Please enter username');
      expect(AuthValidator.validateUsername('   '), 'Please enter username');
    });

    test('accepts non-empty username', () {
      expect(AuthValidator.validateUsername('admin'), isNull);
    });

    test('rejects password shorter than four characters', () {
      expect(
        AuthValidator.validatePassword('123'),
        'Password must contain at least 4 characters',
      );
    });

    test('accepts password with four or more characters', () {
      expect(AuthValidator.validatePassword('1234'), isNull);
    });

    test('validates credentials as a whole', () {
      expect(AuthValidator.isValidCredentials('admin', '1234'), isTrue);
      expect(AuthValidator.isValidCredentials('', '1234'), isFalse);
      expect(AuthValidator.isValidCredentials('admin', '123'), isFalse);
    });
  });
}
