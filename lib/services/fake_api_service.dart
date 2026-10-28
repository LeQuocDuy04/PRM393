import '../models/item.dart';

/// Simulates a remote API call. No real network request is made.
class FakeApiService {
  static Future<List<Item>> fetchItems() async {
    debugLog('1. Bắt đầu gọi fake API');
    await Future<void>.delayed(const Duration(seconds: 2));
    debugLog('2. Fake API trả dữ liệu');

    return const [
      Item(name: 'Táo', price: 10000),
      Item(name: 'Cam', price: 15000),
      Item(name: 'Chuối', price: 8000),
      Item(name: 'Xoài', price: 20000),
      Item(name: 'Nho', price: 35000),
    ];
  }

  static void debugLog(String message) {
    // ignore: avoid_print
    print(message);
  }
}
