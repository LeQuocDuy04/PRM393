# Slot 9 - Simple Product Dashboard App

Flutter exercise implementation based on Slot 9.pdf (exercise pages 21-31).

## Implemented requirements
- Dashboard uses `Column`, `Row`, `Expanded` and responsive available space.
- Reusable `DashboardHeader` uses `Row` and a `Stack` + `Positioned` red notification badge.
- Dashboard summary cards use `Expanded` inside `Row` to share width.
- Named route `/products` navigates from dashboard to product grid.
- Product screen uses `GridView.builder` with 2 columns and scrollable content.
- Reusable `ProductCard` shows icon, name, price, SALE badge and favorite overlay using `Stack`/`Positioned`.
- Product card tap shows a simple product detail bottom sheet.
- iOS URL Scheme concept is documented below; the PDF explicitly says native iOS configuration is not required.

## Run
```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## iOS URL Scheme concept
The example external link is `myapp://products`. In a real iOS app, the operating system would open the app through its registered URL scheme; the app would parse the incoming URL and navigate to `/products`. Slot 9 states that implementing native iOS configuration is optional and is not required for this exercise.

## Project structure
```text
lib/
  main.dart
  screens/
    dashboard_screen.dart
    product_grid_screen.dart
  widgets/
    dashboard_header.dart
    product_card.dart
test/
  widget_test.dart
```
