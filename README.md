# Product Explorer App — Slot 13

Bài tập Flutter tổng hợp theo Slot 13: FutureBuilder, ListView.builder, Loading/Error/Empty UI và màn hình chi tiết gọi API theo ID.

## Chức năng
- GET danh sách sản phẩm: `https://fakestoreapi.com/products`
- GET chi tiết: `https://fakestoreapi.com/products/{id}`
- `FutureBuilder` với loading, error, empty và success state.
- Cache Future trong `initState()` để tránh gọi API lặp khi widget rebuild.
- `ListView.builder` + `ValueKey(product.id)` để render danh sách hiệu quả.
- Retry khi lỗi, nút tải lại và pull-to-refresh.
- Chỉ truyền `productId` khi điều hướng; Detail tự gọi API theo ID.
- Loading/Error độc lập cho màn hình Detail.
- Widget riêng cho Loading, Error và ProductListItem.
- Model JSON parsing và unit tests.

## Cấu trúc
```text
lib/
├── main.dart
├── models/product.dart
├── services/api_service.dart
├── screens/
│   ├── product_list_screen.dart
│   └── product_detail_screen.dart
└── widgets/
    ├── loading_widget.dart
    ├── error_widget.dart
    └── product_list_item.dart
```

## Chạy
Mở terminal tại thư mục dự án:
```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```
Hoặc chạy trên emulator/thiết bị bằng `flutter run`.

## Kiểm thử theo checklist trong tài liệu
1. Có mạng: danh sách tải lên sau trạng thái Loading.
2. Chọn hai sản phẩm khác nhau: mỗi màn hình Detail phải hiện đúng sản phẩm theo ID.
3. Tắt mạng rồi nhấn nút tải lại: hiển thị Error UI; bật mạng và Retry để tải lại.
4. API trả danh sách rỗng: Empty UI được hiển thị (có thể kiểm tra bằng mock test).
5. Cuộn danh sách và rebuild: Future không được khởi tạo lại trong `build()`.

## Lưu ý
API Fake Store là API công khai; cần Internet. Chưa xác nhận build/test trên máy người dùng. Nếu API dịch vụ tạm lỗi, UI Retry sẽ cho phép gọi lại.
