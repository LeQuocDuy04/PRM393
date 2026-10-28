# Slot 3 – All Exercises in One Flutter App

This project combines the Slot3 exercises into one app:

- **Students**: Student model/class, constructors, methods, add student, update GPA, filter with `where()`, and list processing.
- **Functions**: return values, callback formatter, anonymous function, `map()`, `where()`, and converting objects to `Map`.
- **Quick Shop**: Product model, filtering products by price with `where()`, mapping/list rendering, item tap callback, and a simulated cart.

## Run in VS Code

1. Extract the ZIP file.
2. Open the `Slot3_Combined_App` folder in VS Code.
3. Ensure Flutter and Dart extensions are installed and `flutter doctor` has no blocking issue.
4. Open Terminal in VS Code and run:

```bash
flutter pub get
flutter run
```

5. Choose an Android emulator, connected phone, or Chrome if web is enabled.

## Folder structure

```text
Slot3_Combined_App/
├── pubspec.yaml
├── README.md
└── lib/
    ├── main.dart
    ├── data/
    │   └── sample_data.dart
    ├── models/
    │   ├── product.dart
    │   └── student.dart
    ├── services/
    │   ├── product_service.dart
    │   └── student_service.dart
    └── screens/
        ├── functions_screen.dart
        ├── shop_screen.dart
        └── students_screen.dart
```

Note: This is a learning/demo app. Data is stored in memory, so changes reset when the app restarts; the cart is simulated and is not connected to a backend.
