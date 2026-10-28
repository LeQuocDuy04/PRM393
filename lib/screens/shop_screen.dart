import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ShopScreen extends StatefulWidget {
  final ProductService service;
  const ShopScreen({super.key, required this.service});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  double maxPrice = 50;
  final Set<int> cart = {};

  void _addToCart(Product product) {
    setState(() => cart.add(product.id));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} added to cart (demo)')));
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.service.belowPrice(maxPrice);
    return Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text('Quick Shop MVP', style: Theme.of(context).textTheme.headlineSmall)), Badge(label: Text('${cart.length}'), child: const Icon(Icons.shopping_cart_outlined, size: 28))]),
        const SizedBox(height: 8),
        Text('Hiển thị sản phẩm có giá dưới \$${maxPrice.toStringAsFixed(0)}'),
        Slider(value: maxPrice, min: 10, max: 150, divisions: 14, label: '\$${maxPrice.toStringAsFixed(0)}', onChanged: (value) => setState(() => maxPrice = value)),
      ])),
      Expanded(child: products.isEmpty ? const Center(child: Text('Không có sản phẩm phù hợp.')) : ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 12), itemCount: products.length, itemBuilder: (context, index) {
        final product = products[index];
        final inCart = cart.contains(product.id);
        return Card(child: ListTile(
          leading: CircleAvatar(child: Text(product.name[0])),
          title: Text(product.name), subtitle: Text('${product.description}\n\$${product.price.toStringAsFixed(2)}'), isThreeLine: true,
          trailing: IconButton(tooltip: 'Add to cart', onPressed: inCart ? null : () => _addToCart(product), icon: Icon(inCart ? Icons.check_circle : Icons.add_shopping_cart)),
          onTap: () => showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(title: Text(product.name), content: Text('${product.description}\nPrice: \$${product.price.toStringAsFixed(2)}'), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close'))])),
        ));
      })),
    ]);
  }
}
