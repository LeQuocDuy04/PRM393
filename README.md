# Smart Registration App — Slot 11

Flutter practice app for Forms, Controllers, Validation, Error Handling and Submit Flow.

## Structure

```text
lib/
├── main.dart
├── models/
│   └── user_model.dart
├── screens/
│   ├── register_screen.dart
│   └── success_screen.dart
├── services/
│   └── fake_auth_service.dart
└── utils/
    └── validators.dart
```

## Run

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

For Chrome:

```bash
flutter run -d chrome
```

## Required behavior

- Required full name.
- Valid email format.
- Password at least 6 characters.
- Confirm password must match.
- Simulated request waits 2 seconds.
- `test@error.com` triggers a simulated server-side registration error.
- Other valid emails navigate to the success screen.
- Loading indicator appears and the submit button is disabled while submitting.
- Controllers are disposed in `dispose()`.
- Exceptions are caught and shown using a SnackBar.
- Form can be cleared using Clear form.

## Test cases

1. Submit empty form: validation errors appear.
2. Enter malformed email: email error appears.
3. Enter password shorter than 6 characters: password error appears.
4. Enter different confirm password: mismatch error appears.
5. Use `test@error.com` with valid remaining fields: server-error SnackBar appears.
6. Use another valid email and matching passwords: success screen appears after about 2 seconds.
7. Tap submit repeatedly while loading: only one request is processed.

This project uses a fake service only; it does not create a real account or call a backend.
