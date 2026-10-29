# Slot 14 – Smart Task Manager (Offline-first)

Bộ source gồm 3 phiên bản riêng theo nội dung Slot 14:
1. `smart_task_manager_shared_preferences`: CRUD task, JSON serialization, lưu dữ liệu nhỏ bằng SharedPreferences.
2. `smart_task_manager_sqlite`: CRUD task bằng SQLite (`sqflite`), Repository tách khỏi UI, chạy native.
3. `smart_task_manager_drift`: CRUD task bằng Drift, `StreamBuilder` tự cập nhật giao diện khi database thay đổi.

## Cách chạy

Mở terminal trong từng thư mục project và chạy:

```bash
flutter pub get
flutter run
```

Chạy kiểm tra (nếu muốn):

```bash
flutter analyze
flutter test
```

### SharedPreferences
Có thể chạy trên Android/iOS và Flutter Web. Đây là phiên bản dễ nhất để bắt đầu.

### SQLite
Chạy trên Android/iOS hoặc Windows/Linux desktop. Không hỗ trợ Flutter Web vì SQLite native không chạy trên browser theo cấu hình này.

### Drift + Stream
Đây là phiên bản native (Android/iOS/desktop). Sau `flutter pub get`, cần sinh code Drift:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Sau đó chạy:

```bash
flutter run
```

## Kiểm tra bài
- Thêm nhiều task.
- Đánh dấu hoàn thành/chưa hoàn thành.
- Chạm vào task để sửa tiêu đề.
- Xóa từng task và xóa tất cả.
- Đóng app rồi mở lại để kiểm tra dữ liệu còn nguyên.
- Ở bản Drift, khi CRUD, danh sách và thống kê tự cập nhật qua `StreamBuilder`.

Lưu ý: Chưa thể xác nhận build trên máy của bạn. Nếu terminal báo lỗi, gửi ảnh hoặc toàn bộ log để xử lý theo từng bước.
