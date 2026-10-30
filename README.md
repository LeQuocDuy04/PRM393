# Auth Session Demo App – Slot 17, 18, 19

Flutter learning project for **Advance Auth & Project Finalization & Release**.

## Features required by the exercise
- Login form and validation (username required; password at least 4 characters).
- Mock authentication: `admin / 1234`.
- Token persistence using SharedPreferences.
- Automatic session check at app startup.
- Dashboard after successful login.
- Protected Profile route; unauthenticated access redirects to Login.
- Logout clears token and removes protected navigation history.
- Loading indicator, password visibility, and useful error feedback.

## Project structure
```text
lib/
  main.dart
  guards/auth_guard.dart
  screens/
    login_screen.dart
    dashboard_screen.dart
    profile_screen.dart
  services/
    auth_service.dart
    session_service.dart
  utils/
    app_theme.dart
    auth_validator.dart
test/
  auth_validator_test.dart
  session_service_test.dart
  auth_service_test.dart
  login_screen_test.dart
  profile_screen_test.dart
docs/
  DEBUGGING_GUIDE.md
  USER_TEST_CHECKLIST.md
  TEST_REPORT.md
  RELEASE_GUIDE.md
```

## Run on Windows
Open the project folder in VS Code / Android Studio, then:
```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

Use `admin` / `1234` to log in.

## Test scenarios
1. Empty username → validation error.
2. Password shorter than 4 characters → validation error.
3. Wrong password → Login failed.
4. Correct credentials → Dashboard.
5. Dashboard → Open Profile.
6. Profile → Logout → Login; back navigation must not reopen Profile.
7. Login, stop app completely, run again → Dashboard (session persists).
8. Logout, stop app completely, run again → Login.

## Build and release
Follow [`docs/RELEASE_GUIDE.md`](docs/RELEASE_GUIDE.md). Run tests and static analysis before generating release artifacts.

## Important notes
- This is mock authentication, not a real backend login.
- SharedPreferences is used to satisfy the exercise. Do not store production secrets this way.
- The ZIP contains app source, automated tests, test documentation and release instructions. Android Gradle wrapper/platform files are generated on the target machine with `flutter create --platforms=android --org com.example .` as described in the release guide.
- Automated tests and release builds must be executed on your machine; this environment does not include the Flutter SDK, so no passing test/build result is claimed.
