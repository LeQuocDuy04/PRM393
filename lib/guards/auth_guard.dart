import '../services/auth_service.dart';

class AuthGuard {
  const AuthGuard._();

  static Future<bool> canOpenProfile(AuthService authService) {
    return authService.hasValidSession();
  }
}
