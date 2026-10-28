# Student Manager App — Slot 8

Bài Flutter dựa theo `Slot8.pdf`: Named Routes & Arguments, Navigator 1.0 (push/pop), nhận thức Navigator 2.0 và Android Deep Linking.

## Chức năng

- Home → Student List bằng Named Route (`Navigator.pushNamed`).
- Danh sách dùng `ListView.builder` và widget riêng `StudentTile`.
- Chọn sinh viên → Detail bằng Named Route + `Student` arguments.
- Detail kiểm tra arguments và hiển thị màn hình an toàn nếu thiếu/sai dữ liệu.
- Thêm sinh viên bằng `Navigator.push` + `Navigator.pop(context, student)` trả kết quả về danh sách.
- Chỉnh sửa sinh viên từ Detail, cập nhật dữ liệu in-memory.
- Route name được gom tại `lib/routes/app_routes.dart`.
- Android custom deep link `studentapp://student/detail?id=S001`, parse `id` trong `onGenerateRoute`.
- Có widget tests cơ bản.
- Dữ liệu mẫu chỉ lưu trong bộ nhớ, không dùng database (đúng mục tiêu bài tập).

## Cấu trúc chính

```text
lib/
├── main.dart
├── models/
│   ├── student.dart
│   └── student_store.dart
├── routes/
│   └── app_routes.dart
├── screens/
│   ├── home_screen.dart
│   ├── student_list_screen.dart
│   ├── student_detail_screen.dart
│   └── student_form_screen.dart
└── widgets/
    └── student_tile.dart
```

## Cách chạy

Nếu đã có Flutter SDK, mở terminal tại thư mục project rồi chạy:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Nếu máy báo không có Android device, xem danh sách thiết bị bằng `flutter devices`; có thể dùng Chrome với `flutter run -d chrome` để kiểm tra các luồng trong app (deep link Android chỉ kiểm tra trên Android emulator/thiết bị).

> Thư mục Android trong gói này cung cấp `AndroidManifest.xml` có intent-filter deep link. Nếu tạo project Flutter mới bằng `flutter create student_manager_app`, hãy chép thư mục `lib/`, `test/`, `pubspec.yaml` vào project đó và thêm intent-filter deep link vào thẻ `<activity>` của file `android/app/src/main/AndroidManifest.xml` được Flutter tạo sẵn. Giữ các phần cấu hình Android còn lại do Flutter sinh ra, đặc biệt theme và launcher icon.

## Kiểm tra Android Deep Link

Chạy app trên Android Emulator/thiết bị đã cài app, sau đó dùng terminal có `adb`:

```bash
adb shell am start -a android.intent.action.VIEW -d "studentapp://student/detail?id=S001"
```

Kết quả mong đợi: app mở màn hình chi tiết của sinh viên `S001`. Thử `S999` để xem màn hình fallback khi mã không tồn tại.

## User flow

1. Mở app → Home.
2. Nhấn **Xem danh sách sinh viên** → Student List.
3. Chạm một sinh viên → Student Detail (arguments là `Student`).
4. Nhấn **Quay lại danh sách** → quay lại List.
5. Nhấn **Thêm sinh viên** → Form; nhập hợp lệ và lưu → quay lại List, thấy sinh viên mới.
6. Từ Detail nhấn **Chỉnh sửa sinh viên** → Form; lưu → Detail/List nhận dữ liệu đã cập nhật.
7. Mở bằng deep link → vào thẳng Detail theo mã sinh viên.

## Navigator 2.0 — phần nhận thức

Bài tập không triển khai RouterDelegate/RouteInformationParser đầy đủ; phần này được thể hiện trong README theo đúng phạm vi PDF: state-based navigation là tư duy nền tảng. Trong app thực tế, trạng thái đăng nhập/role/deep link có thể quyết định page nào cần hiển thị thay vì gọi push/pop thủ công.
