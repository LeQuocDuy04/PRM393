$ErrorActionPreference = "Stop"
flutter pub get
flutter test
flutter analyze
flutter build apk --release
Write-Host "APK: build\app\outputs\flutter-apk\app-release.apk"
