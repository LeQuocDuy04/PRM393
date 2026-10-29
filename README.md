# Slot 15 – Smart Todo Backup App

Ứng dụng Flutter thực hành state-driven UI, ListView.builder, model JSON và export/backup JSON theo yêu cầu trong Slot 15.pdf.

## Chức năng
- Hiển thị danh sách Todo từ `List<Todo>`.
- Thêm Todo bằng TextField và nút `+`.
- Chạm vào Todo để đổi trạng thái hoàn thành; item hoàn thành được gạch ngang.
- Hiển thị tổng số công việc và số đã hoàn thành.
- Export JSON bằng nút Save trên AppBar: in JSON ra Debug Console và hiển thị nội dung trên màn hình.
- Import danh sách JSON mẫu để minh họa `fromJson`.
- Tách code theo `models`, `screens`, `widgets`, `services`.
- Kiểm tra JSON đầu vào, có unit tests cho model và service.

## Cấu trúc
```text
lib/
├── main.dart
├── models/
│   └── todo.dart
├── screens/
│   └── home_screen.dart
├── widgets/
│   └── todo_item.dart
└── services/
    └── json_service.dart
test/
└── todo_test.dart
```

## Cách chạy
Mở terminal tại thư mục `todo_backup_app`:

```bash
flutter pub get
flutter run
```

Chọn emulator hoặc thiết bị có trong `flutter devices`. Để kiểm tra code và test:

```bash
flutter analyze
flutter test
```

## Kiểm chứng theo đề
1. Thêm 5–10 Todo, kiểm tra danh sách cuộn được.
2. Chạm vào Todo để thấy gạch ngang thay đổi ngay (`setState`).
3. Nhấn biểu tượng Save trên AppBar, xem JSON trong Debug Console hoặc hộp thoại.
4. Nhấn biểu tượng mở file để nạp 2 Todo mẫu, kiểm tra UI cập nhật.
5. Dữ liệu chỉ nằm trong bộ nhớ khi app đang chạy; JSON export ở bài cơ bản là backup ra console/UI, chưa lưu file thật và chưa giữ Todo sau khi đóng app.
