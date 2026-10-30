# Test Report – Auth Session Demo App

## 1. Scope
This report covers input validation, mock authentication, token persistence, auth flow, protected Profile access, logout, and core Login/Profile UI behavior.

## 2. Automated test inventory

| Test file | Test type | Coverage |
|---|---|---|
| `auth_validator_test.dart` | Unit | Empty username, password length, combined validation |
| `session_service_test.dart` | Unit | Save, read, missing token, clear token |
| `auth_service_test.dart` | Unit | Successful login, invalid login, logout |
| `login_screen_test.dart` | Widget | Login form, validation messages, successful navigation |
| `profile_screen_test.dart` | Widget | Protected profile redirect, profile display, logout |

## 3. How to execute
```bash
flutter pub get
flutter test
flutter analyze
```

## 4. Result recording

| Item | Result | Evidence / notes |
|---|---|---|
| Unit tests | Pending execution on developer machine | Run `flutter test` |
| Widget tests | Pending execution on developer machine | Run `flutter test` |
| Static analysis | Pending execution on developer machine | Run `flutter analyze` |
| Manual user testing | Pending tester execution | Complete `USER_TEST_CHECKLIST.md` |
| Android release build | Pending Android SDK / signing setup | Follow `RELEASE_GUIDE.md` |

## 5. Known scope limitations
- Authentication is mock-only (`admin / 1234`); there is no backend or real user account.
- SharedPreferences is used for this learning exercise. A production app should use an appropriate secure-storage solution for sensitive credentials/tokens.
- This report is a test plan and result template. It does not claim tests or real-device testing have already passed.
