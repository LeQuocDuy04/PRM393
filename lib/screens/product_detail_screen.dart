import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    // Detail always requests by ID and caches its Future for this screen.
    _productFuture = ApiService.fetchProductById(widget.productId);
  }

  void _retry() {
    setState(() {
      _productFuture = ApiService.fetchProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Đang tải chi tiết sản phẩm...');
          }

          if (snapshot.hasError) {
            return AppErrorWidget(
              message: 'Không thể tải sản phẩm #${widget.productId}.\n'
                  'Vui lòng kiểm tra mạng rồi thử lại.',
              onRetry: _retry,
            );
          }

          final product = snapshot.data;
          if (product == null) {
            return AppErrorWidget(
              message: 'Không tìm thấy dữ liệu sản phẩm.',
              onRetry: _retry,
            );
          }

          return _buildDetails(product);
        },
      ),
    );
  }

  Widget _buildDetails(Product product) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 280,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported_outlined,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              if (product.category.isNotEmpty)
                Chip(
                  label: Text(product.category),
                  avatar: const Icon(Icons.category_outlined, size: 18),
                ),
              const SizedBox(height: 8),
              Text(
                product.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.star_rounded, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('${product.rating.toStringAsFixed(1)} (${product.ratingCount} đánh giá)'),
                ],
              ),
              const Divider(height: 32),
              Text('Mô tả sản phẩm', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Quay lại danh sách'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
