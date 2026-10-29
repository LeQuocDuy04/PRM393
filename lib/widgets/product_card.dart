import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.index, required this.onTap});

  final int index;
  final VoidCallback onTap;

  static const List<IconData> _icons = [
    Icons.headphones_rounded,
    Icons.watch_rounded,
    Icons.backpack_rounded,
    Icons.camera_alt_rounded,
    Icons.speaker_rounded,
    Icons.keyboard_rounded,
    Icons.phone_iphone_rounded,
    Icons.laptop_mac_rounded,
  ];
  static const List<Color> _colors = [
    Color(0xFFE0E7FF), Color(0xFFD1FAE5), Color(0xFFFEF3C7), Color(0xFFFCE7F3),
    Color(0xFFEDE9FE), Color(0xFFFFEDD5), Color(0xFFCFFAFE), Color(0xFFF3F4F6),
  ];

  @override
  Widget build(BuildContext context) {
    final iconIndex = index % _icons.length;
    final price = 10 + index;
    final isSale = index % 4 == 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(color: _colors[iconIndex], borderRadius: BorderRadius.circular(15)),
                        child: Center(child: Icon(_icons[iconIndex], size: 58, color: const Color(0xFF3730A3))),
                      ),
                      if (isSale)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(8)),
                            child: const Text('SALE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                          ),
                        ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
                          child: const Icon(Icons.favorite_border_rounded, size: 17, color: Color(0xFF374151)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Product #$index', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(child: Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w800, fontSize: 15))),
                  const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                  const Text('4.8', style: TextStyle(fontSize: 11, color: Color(0xFF737B8C))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
