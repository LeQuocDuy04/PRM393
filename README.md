# Responsive Dashboard App — Slot 10

Flutter assignment practicing responsive UI with `MediaQuery`, `LayoutBuilder`, flexible summary cards, and a responsive product grid.

## Folder structure

```text
lib/
├── main.dart
├── screens/
│   └── dashboard_screen.dart
└── widgets/
    ├── summary_card.dart
    └── responsive_grid.dart
```

## Run

```bash
flutter pub get
flutter analyze
flutter run
```

To run in Chrome if the Flutter web target is enabled:

```bash
flutter run -d chrome
```

## Responsive rules

- Summary cards stack vertically when their allocated width is below 600 logical pixels.
- Summary cards are arranged in a row with `Expanded` on wider layouts.
- Product grid uses 2 columns below 600, 3 columns from 600 to below 900, and 4 columns at 900 or wider.
- `MediaQuery` is used for screen-level padding and typography.
- `LayoutBuilder` uses the actual available width for summary and grid layout decisions.
- Long text uses `maxLines` and `TextOverflow.ellipsis` to prevent overflow.

## Test checklist

1. Small phone: summary cards stacked; grid has 2 columns.
2. Large phone: no horizontal overflow; grid has 2 columns.
3. Tablet: summary cards arranged horizontally; grid has 3 or 4 columns depending on available width.
4. Resize the app window if running on web/desktop and observe the grid column count change.
