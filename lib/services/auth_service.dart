import 'session_service.dart';

class AuthService {
  static Future<bool> login(String username, String password) async {
    final normalizedUsername = username.trim();

    if (normalizedUsername == 'admin' && password == '1234') {
      await SessionService.saveSession(normalizedUsername);
      return true;
    }

    return false;
  }

  static Future<void> logout() async {
    await SessionService.clearSession();
  }
}
