# Debugging Guide

The assignment expects a repeatable process: identify the issue → inspect logs → inspect values with breakpoints → fix → rerun tests.

## Logs included in this project
- `AuthService.login`: logs username only, never the password.
- `AuthService.hasValidSession`: logs whether the saved mock token is valid.
- `AuthService.logout`: logs when the session is cleared.
- Login screen: logs caught exceptions and stack traces.

## VS Code / Android Studio workflow
1. Run the app in Debug mode (`flutter run`).
2. Open the Debug Console / Run console and reproduce the issue.
3. Set breakpoints in `AuthService.login`, `SessionService.readToken`, or `ProfileScreen._logout`.
4. Inspect username, success result, token presence, and navigation call. Never inspect or log a real password.
5. Step over / step into the async calls and confirm each `await` completes.
6. Fix the cause, rerun `flutter test`, then reproduce the original scenario.

## Useful commands
```bash
flutter analyze
flutter test
flutter run -v
flutter run --release
```

## Example: app returns to Login after restart
- Breakpoint: `main()` before `hasValidSession()`.
- Breakpoint: `SessionService.readToken()`.
- Confirm the key is `auth_token`, token is non-empty, and the stored value equals the mock token.
- Check that saving the token is awaited before navigation.
