import 'package:flutter_test/flutter_test.dart';
import 'package:smart_profile_editor/models/profile_model.dart';

void main() {
  group('Profile model', () {
    test('parses JSON safely', () {
      final profile = Profile.fromJson({
        'name': 'Le Duy',
        'email': 'duy@example.com',
        'phone': 123456789,
      });

      expect(profile.name, 'Le Duy');
      expect(profile.email, 'duy@example.com');
      expect(profile.phone, '123456789');
    });

    test('converts to JSON and copyWith works', () {
      const profile = Profile(
        name: 'A',
        email: 'a@example.com',
        phone: '0123456789',
      );

      expect(profile.toJson()['name'], 'A');
      expect(profile.copyWith(name: 'B').name, 'B');
    });

    test('profiles compare by field values', () {
      const a = Profile(name: 'A', email: 'a@b.com', phone: '12345678');
      const b = Profile(name: 'A', email: 'a@b.com', phone: '12345678');
      expect(a, b);
    });
  });
}
