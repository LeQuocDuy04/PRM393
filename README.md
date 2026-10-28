# Slot 6 — Student List Interaction App

Ứng dụng làm theo yêu cầu trong `Slot6_1.pdf` (Bài tập tổng hợp 1, phần Student List Interaction App và bản nâng cấp Detail Screen).

## Chức năng
- Hiển thị danh sách sinh viên bằng `ListView.builder`.
- Mỗi item được tách thành `StudentCard`, dùng `Card` + `ListTile`.
- Hiển thị tên, mã sinh viên và avatar chữ cái đầu.
- Bấm icon ở cuối item để chọn/bỏ chọn; icon và trạng thái được cập nhật bằng `setState`.
- Bấm phần còn lại của item để mở `Student Detail Screen`.
- Trang chi tiết hiển thị ID, email, chuyên ngành và trạng thái chọn.
- Có thanh thống kê số sinh viên và số sinh viên được chọn.
- Có dữ liệu mẫu; không cần backend hay package bên ngoài.

## Cấu trúc
```text
lib/
├── main.dart
├── models/
│   └── student.dart
├── screens/
│   ├── home_screen.dart
│   └── student_detail_screen.dart
└── widgets/
    └── student_card.dart
```

## Chạy
```powershell
flutter pub get
flutter analyze
flutter run
```
Có thể chạy Chrome bằng `flutter run -d chrome`, hoặc Windows bằng `flutter run -d windows` nếu máy cho phép chạy ứng dụng desktop.

## Điểm kiến thức
- `MaterialApp`: cấu hình toàn ứng dụng.
- `Scaffold`: khung của từng screen.
- `ListView.builder`: tạo item theo dữ liệu và hỗ trợ cuộn.
- `Card` + `ListTile`: giao diện item thống nhất.
- `VoidCallback`: tách hành động khỏi widget hiển thị.
- `setState`: cập nhật trạng thái UI local.
- `Navigator.push`: điều hướng được xử lý tại `HomeScreen`, không nằm trong `StudentCard`.
