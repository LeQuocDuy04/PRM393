import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/product_list_item.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    // Cache the Future here: rebuilding the UI will not trigger another GET.
    _productsFuture = ApiService.fetchProducts();
  }

  void _retry() {
    setState(() {
      _productsFuture = ApiService.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Explorer'),
        actions: [
          IconButton(
            tooltip: 'Tải lại sản phẩm',
            onPressed: _retry,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Đang tải danh sách sản phẩm...');
          }

          if (snapshot.hasError) {
            return AppErrorWidget(
              message: _friendlyError(snapshot.error),
              onRetry: _retry,
            );
          }

          final products = snapshot.data;
          if (products == null || products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 52),
                    const SizedBox(height: 12),
                    Text('Chưa có sản phẩm nào', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text('Hãy thử tải lại danh sách.'),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tải lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _retry();
              try {
                await _productsFuture;
              } catch (_) {
                // FutureBuilder displays the error state.
              }
            },
            child: ListView.builder(
              key: const PageStorageKey<String>('product-list'),
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductListItem(
                  key: ValueKey<int>(product.id),
                  product: product,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ProductDetailScreen(productId: product.id),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _friendlyError(Object? error) {
    final text = error.toString();
    if (text.toLowerCase().contains('timeout')) {
      return 'Kết nối quá thời gian. Kiểm tra mạng rồi thử lại.';
    }
    return 'Vui lòng kiểm tra kết nối Internet và thử lại.\nChi tiết: $text';
  }
}
