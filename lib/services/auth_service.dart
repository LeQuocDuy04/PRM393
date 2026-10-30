import 'package:flutter/foundation.dart';

import 'session_service.dart';

class AuthService {
  AuthService({required SessionService sessionService})
      : _sessionService = sessionService;

  final SessionService _sessionService;

  // Mock authentication as required by the exercise.
  static const String _mockUsername = 'admin';
  static const String _mockPassword = '1234';
  static const String _mockToken = 'mock_token_admin';

  Future<bool> login(String username, String password) async {
    debugPrint('[AuthService] Login attempt for username: ${username.trim()}');

    final success = username.trim() == _mockUsername &&
        password == _mockPassword;

    if (!success) {
      debugPrint('[AuthService] Login rejected');
      return false;
    }

    await _sessionService.saveToken(_mockToken);
    debugPrint('[AuthService] Mock session saved');
    return true;
  }

  Future<void> logout() async {
    await _sessionService.clearToken();
    debugPrint('[AuthService] Session cleared');
  }

  Future<bool> hasValidSession() async {
    final token = await _sessionService.readToken();
    final valid = token == _mockToken;
    debugPrint('[AuthService] Session check: $valid');
    return valid;
  }
}
