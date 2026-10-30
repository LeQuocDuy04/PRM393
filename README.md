# Auth Session Demo App — Slot 16

## Requirements
- Flutter SDK
- Dart SDK
- Android emulator, physical device, or supported desktop/web target

## Run
```bash
flutter pub get
flutter run
```

## Demo account
- Username: `admin`
- Password: `1234`

## Features
- Login form and validation
- Mock authentication
- Session persistence with shared_preferences
- Session check at app startup
- Guarded Dashboard and Profile routes
- Logout clears session and navigation history

## Test checklist
1. Login with `admin / 1234`: Dashboard opens.
2. Login with an incorrect password: `Login failed` appears.
3. Open Profile while logged in: Profile opens.
4. Logout: app returns to Login and cannot navigate back to protected screens.
5. Stop and restart after login: Dashboard opens automatically.
6. Stop and restart after logout: Login opens.
7. Try opening `/profile` or `/dashboard` without a session: app redirects to Login.

Note: This is mock authentication for learning. Credentials are hard-coded and must not be used in a production app.
