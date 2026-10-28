# Slot 4 – Combined Flutter Exercises

Dự án gộp hai bài tập thực hành chính trong `Slot4.pdf` thành một ứng dụng Flutter duy nhất.

## Chức năng

### 1. Future Product Loader
- `Item` model tách dữ liệu khỏi giao diện.
- `FakeApiService.fetchItems()` mô phỏng API bằng `Future.delayed` 2 giây.
- `FutureBuilder` hiển thị đủ trạng thái loading, error và data.
- Nút Reload Future gọi tải lại dữ liệu.
- Future được lưu trong state, không tạo lại vô tình ở mỗi lần `build()`.

### 2. Stream Counter
- `CounterStreamService` sử dụng `StreamController<int>` và `Timer.periodic`.
- `StreamBuilder` cập nhật số đếm mỗi giây mà không cần reload thủ công.
- Có nút Pause, Resume và Reset.
- `dispose()` hủy timer và đóng StreamController để tránh rò rỉ tài nguyên.

Không cần API thật, Firebase hay Socket; dữ liệu đều được mô phỏng theo yêu cầu bài tập.

## Cấu trúc

```text
lib/
├── main.dart
├── models/
│   └── item.dart
├── services/
│   ├── fake_api_service.dart
│   └── counter_stream_service.dart
└── screens/
    ├── future_product_screen.dart
    └── stream_counter_screen.dart
```

## Chạy trên Windows

1. Giải nén ZIP và mở thư mục `Slot4_Combined_App` bằng VS Code.
2. Mở Terminal tại thư mục gốc.
3. Nếu dự án chưa có thư mục `windows/`, chạy:

   ```powershell
   flutter create --platforms=windows .
   ```

4. Cài dependencies và chạy:

   ```powershell
   flutter pub get
   flutter run -d windows
   ```

Cần cài Visual Studio với workload **Desktop development with C++** để build ứng dụng Windows.

## Chạy trên Chrome (tùy chọn)

Nếu chưa có thư mục `web/`, chạy `flutter create --platforms=web .`, sau đó:

```powershell
flutter pub get
flutter run -d chrome
```

## Kiểm tra

```powershell
flutter analyze
flutter run -d windows
```

Lưu ý: source được tạo theo yêu cầu trong PDF nhưng chưa được biên dịch thử bằng Flutter SDK trong môi trường tạo file.

## Phần AI Base Learning

Các prompt ở cuối PDF là câu hỏi tự nghiên cứu/phân tích, không phải chức năng bắt buộc của ứng dụng. Nội dung code tập trung vào hai bài tập thực hành: Future Product Loader và Stream Counter.
