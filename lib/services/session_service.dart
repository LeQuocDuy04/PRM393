import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String tokenKey = 'auth_token';

  Future<void> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(tokenKey, token);
  }

  Future<String?> readToken() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(tokenKey);
    if (token == null || token.trim().isEmpty) {
      return null;
    }
    return token;
  }

  Future<void> clearToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(tokenKey);
  }

  Future<bool> hasToken() async => (await readToken()) != null;
}
