import 'package:flutter_test/flutter_test.dart';
import 'package:product_explorer/models/product.dart';

void main() {
  group('Product model', () {
    test('parses API JSON including rating', () {
      final product = Product.fromJson({
        'id': 1,
        'title': 'Test product',
        'description': 'Description',
        'image': 'https://example.com/image.png',
        'price': 12.5,
        'category': 'electronics',
        'rating': {'rate': 4.2, 'count': 9},
      });

      expect(product.id, 1);
      expect(product.title, 'Test product');
      expect(product.price, 12.5);
      expect(product.rating, 4.2);
      expect(product.ratingCount, 9);
    });

    test('uses safe defaults when optional rating is missing', () {
      final product = Product.fromJson({
        'id': 2,
        'title': 'Test',
        'description': '',
        'image': '',
        'price': 1,
      });

      expect(product.rating, 0);
      expect(product.ratingCount, 0);
      expect(product.category, '');
    });
  });
}
