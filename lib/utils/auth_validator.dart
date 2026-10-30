class AuthValidator {
  const AuthValidator._();

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter username';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 4) {
      return 'Password must contain at least 4 characters';
    }
    return null;
  }

  static bool isValidCredentials(String username, String password) {
    return validateUsername(username) == null &&
        validatePassword(password) == null;
  }
}
