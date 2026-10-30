# Android Build & Release Guide

## App identity and version
- Display name: Auth Session Demo
- Package name (applicationId): `com.example.auth_session_demo`
- Version: `1.0.0+1` in `pubspec.yaml` (`versionName` + `versionCode` are generated from it).

## Generate Android platform files
This source bundle keeps the Flutter app code platform-independent. From the project root, run:
```powershell
flutter create --platforms=android --org com.example .
```
If Flutter reports that the Android platform already exists, keep the generated Android project and do not overwrite it.

## Set app display name
In `android/app/src/main/AndroidManifest.xml`, set the `<application>` label to:
```xml
android:label="Auth Session Demo"
```

## App icon
A 1024x1024 icon is included at `assets/app_icon.png`. The `flutter_launcher_icons` dependency and configuration are already present in `pubspec.yaml`. After generating the Android/iOS platform folders, run:
```bash
flutter pub get
dart run flutter_launcher_icons
```
Check the generated Android mipmap and iOS AppIcon assets before release.

## Android signing (release)
1. Create a keystore locally (do not commit it):
```powershell
keytool -genkey -v -keystore $env:USERPROFILE\auth-session-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
2. Create `android/key.properties`:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=C:\\Users\\YOUR_USER\\auth-session-release.jks
```
3. In `android/app/build.gradle.kts`, add the following Kotlin DSL signing configuration near the top (after the `plugins` block):
```kotlin
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```
Merge the `android { ... }` contents into the existing `android` block; do not create a second `android` block. Never commit `key.properties` or `.jks`.
4. Add both to `.gitignore`. The ZIP already ignores `android/key.properties` and `*.jks`.

## Build
```bash
flutter pub get
flutter test
flutter analyze
flutter build apk --release
flutter build appbundle --release
```
APK output: `build/app/outputs/flutter-apk/app-release.apk`  
AAB output: `build/app/outputs/bundle/release/app-release.aab`

Install and test the APK on a real Android device before calling the release verified:
```bash
flutter install --release
```

## Debug vs Release
- Debug: development, logs, debugging, not optimized for distribution.
- Release: optimized build intended for testing/distribution; verify the real release package.
- iOS IPA creation requires macOS, Xcode, Apple signing assets and provisioning; it cannot be completed on Windows.
