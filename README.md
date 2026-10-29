# Smart Profile Editor — Slot 12

Flutter app thực hành các yêu cầu trong Slot 12: Form validation, Draft Save, Focus/Keyboard, HTTP GET/PUT, JSON parsing và Repository pattern.

## Chức năng
- Tải profile qua GET từ JSONPlaceholder (`/users/1`).
- Parse JSON thành `Profile` model.
- Form có Họ tên, Email, Số điện thoại và validation.
- Focus chuyển qua Next; Done ở trường cuối sẽ submit.
- Tự động lưu draft vào SharedPreferences sau 700 ms (debounce).
- Khi mở lại app, ưu tiên khôi phục draft; nếu không có thì tải từ API.
- PUT cập nhật, loading overlay, thông báo thành công/lỗi và xóa draft khi thành công.
- Timeout 10 giây, kiểm tra status code 2xx, custom `ApiException`.
- Scroll khi bàn phím mở, tap ngoài để ẩn bàn phím, xác nhận khi thoát nếu có thay đổi.
- Model unit tests.

## Cấu trúc
```text
lib/
├── core/
│   └── exceptions.dart
├── models/
│   └── profile_model.dart
├── repositories/
│   └── profile_repository.dart
├── screens/
│   └── profile_screen.dart
├── services/
│   ├── api_service.dart
│   └── draft_service.dart
└── main.dart
```

## Chạy ứng dụng
Mở terminal tại thư mục `smart_profile_editor`, chạy:

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Có thể thay `-d chrome` bằng thiết bị/emulator đang dùng, ví dụ `flutter run`.

## Kiểm tra bài
1. Mở app có kết nối mạng: lần đầu tải dữ liệu API.
2. Nhập email sai hoặc số điện thoại ít hơn 8 chữ số: form báo lỗi.
3. Nhấn Next trên keyboard để chuyển field; nhấn Done để submit.
4. Sửa thông tin, chờ dòng lưu nháp; đóng và mở lại app để kiểm tra draft.
5. Thay đổi dữ liệu hợp lệ rồi bấm Lưu cập nhật; kiểm tra loading, thông báo thành công và draft được xóa.
6. Tắt mạng để kiểm tra trạng thái lỗi và nút thử lại.

## Lưu ý
JSONPlaceholder là API giả lập công khai. PUT thường trả response thành công nhưng **không lưu thay đổi lâu dài**. SharedPreferences lưu draft cục bộ trên thiết bị.
