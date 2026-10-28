import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/fake_api_service.dart';

class FutureProductScreen extends StatefulWidget {
  const FutureProductScreen({super.key});

  @override
  State<FutureProductScreen> createState() => _FutureProductScreenState();
}

class _FutureProductScreenState extends State<FutureProductScreen> {
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = FakeApiService.fetchItems();
  }

  void _reloadItems() {
    setState(() {
      // Store the Future instead of creating a new one on every build.
      _itemsFuture = FakeApiService.fetchItems();
    });
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0)} VND';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 1: Future Product Loader'),
        actions: [
          IconButton(
            tooltip: 'Tải lại sản phẩm',
            onPressed: _reloadItems,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Future trả dữ liệu một lần. Chờ khoảng 2 giây để xem loading rồi danh sách sẽ xuất hiện.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Item>>(
              future: _itemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Đang tải sản phẩm...'),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, size: 48),
                          const SizedBox(height: 12),
                          Text('Không tải được dữ liệu: ${snapshot.error}'),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: _reloadItems,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final items = snapshot.data;
                if (items == null || items.isEmpty) {
                  return const Center(child: Text('Không có sản phẩm.'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _reloadItems(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(item.name),
                          subtitle: Text(_formatPrice(item.price)),
                          trailing: const Icon(Icons.check_circle_outline),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _reloadItems,
        icon: const Icon(Icons.refresh),
        label: const Text('Reload Future'),
      ),
    );
  }
}
