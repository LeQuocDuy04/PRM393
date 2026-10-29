import 'package:flutter/material.dart';

import '../widgets/product_card.dart';

class ProductGridScreen extends StatelessWidget {
  const ProductGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products', style: TextStyle(fontWeight: FontWeight.w800)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Product catalog', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              const Text('Find something you will love.', style: TextStyle(color: Color(0xFF737B8C))),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13)),
                    child: const Row(children: [Icon(Icons.search_rounded, color: Color(0xFF737B8C)), SizedBox(width: 8), Text('Search products', style: TextStyle(color: Color(0xFF9CA3AF)))]),
                  ),
                ),
                const SizedBox(width: 10),
                Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.tune_rounded)),
              ]),
              const SizedBox(height: 16),
              const Row(children: [Text('All products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)), Spacer(), Text('24 items', style: TextStyle(color: Color(0xFF737B8C), fontSize: 12))]),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  itemCount: 24,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) => ProductCard(
                    index: index,
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
                      showDragHandle: true,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Product #$index', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          Text('Price: \$${(10 + index).toStringAsFixed(2)}', style: const TextStyle(fontSize: 17, color: Color(0xFF4F46E5), fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          const Text('Demo product information. This exercise focuses on layout and navigation.'),
                          const SizedBox(height: 16),
                          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
