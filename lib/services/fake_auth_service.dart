import '../models/user_model.dart';

class FakeAuthService {
  /// Simulates a backend request. No real account is created.
  Future<void> register(UserModel user) async {
    await Future.delayed(const Duration(seconds: 2));

    if (user.email.trim().toLowerCase() == 'test@error.com') {
      throw const RegistrationException('This email is already registered.');
    }
  }
}

class RegistrationException implements Exception {
  final String message;

  const RegistrationException(this.message);

  @override
  String toString() => message;
}
