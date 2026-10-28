# Slot 5 – Combined Flutter Practice App

Ứng dụng tổng hợp các bài thực hành chính trong `Slot5.pdf`, không dùng Provider, Bloc, RxDart hoặc state-management framework nâng cao.

## Các màn hình

1. **Live Stream** – Bài tổng hợp 1 và 2: counter realtime mỗi giây, `StreamController`, `StreamBuilder`, loading/data/error, pause/resume/reset, lỗi mô phỏng bằng `addError`, log dữ liệu.
2. **Repository** – Bài tổng hợp 3: `User` model, fake data source, abstract `UserRepository`, implementation, `FutureBuilder`; nút đổi nguồn dữ liệu mô phỏng mà không sửa UI hiển thị danh sách.
3. **Reactive UI** – Bài tổng hợp 4: dữ liệu nằm ở service, UI không tạo Stream hoặc phát dữ liệu; hai widget cùng lắng nghe broadcast Stream, pause/resume/reset, log rebuild để quan sát reactive behavior.

## Cấu trúc

```text
lib/
├── main.dart
├── models/
│   └── user.dart
├── data/
│   ├── datasources/
│   │   ├── user_fake_datasource.dart
│   │   └── user_alternate_datasource.dart
│   └── repositories/
│       ├── user_repository.dart
│       └── user_repository_impl.dart
├── services/
│   └── counter_stream_service.dart
└── screens/
    ├── live_counter_screen.dart
    ├── user_list_screen.dart
    └── reactive_counter_screen.dart
```

## Chạy trên Windows

Mở Terminal tại thư mục `Slot5_Combined_App`:

```powershell
flutter create --platforms=windows,web .
flutter pub get
flutter analyze
flutter run -d windows
```

Có thể chạy web bằng `flutter run -d chrome`. Để chạy ứng dụng Windows cần Visual Studio với workload **Desktop development with C++**.

## Luồng dữ liệu

- Counter: `Timer → CounterStreamService → StreamController → StreamBuilder → UI`
- User list: `UserScreen → UserRepository → UserRepositoryImpl → DataSource → FutureBuilder → UI`
- Reactive: service giữ dữ liệu và emit; các widget lắng nghe rồi tự render. Không dùng `setState()` để cập nhật giá trị counter từ Stream.

## Câu hỏi ôn tập theo yêu cầu Slot 5

- **Future vs Stream:** Future trả một kết quả bất đồng bộ; Stream có thể phát nhiều giá trị theo thời gian.
- **Repository Pattern:** lớp trung gian che giấu nguồn dữ liệu. UI phụ thuộc contract `UserRepository`, không phụ thuộc datasource cụ thể.
- **Repository vs Service:** trong ví dụ này, datasource mô phỏng nơi lấy dữ liệu; repository điều phối và cung cấp contract ổn định cho UI. Tên gọi có thể khác nhau giữa các kiến trúc.
- **Reactive Thinking:** dữ liệu thay đổi → Stream emit → widget lắng nghe → UI render. UI không quyết định thời điểm dữ liệu thay đổi.
- **Imperative vs Reactive:** imperative thường giữ state ở UI và gọi `setState`; reactive tách dữ liệu khỏi UI và render theo dữ liệu được phát.

## Ghi chú

Dữ liệu user và counter đều được mô phỏng trong máy, không cần backend hay API key. Source code được tạo theo yêu cầu trong PDF; hãy chạy `flutter analyze` và `flutter run` trên máy đã cài Flutter để kiểm tra theo môi trường của bạn.
