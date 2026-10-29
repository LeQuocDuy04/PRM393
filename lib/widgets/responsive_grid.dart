import 'package:flutter/material.dart';

class ResponsiveProductGrid extends StatelessWidget {
  const ResponsiveProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the width actually allocated to this grid, not the full screen.
        final maxWidth = constraints.maxWidth;
        final int crossAxisCount;

        if (maxWidth < 600) {
          crossAxisCount = 2;
        } else if (maxWidth < 900) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 4;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Products',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172554),
                    ),
                  ),
                ),
                Text(
                  '12 items',
                  style: TextStyle(color: Colors.blueGrey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Available products • $crossAxisCount columns',
              style: TextStyle(color: Colors.blueGrey.shade600),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 12,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: maxWidth < 400 ? 0.95 : 1.15,
              ),
              itemBuilder: (context, index) {
                return _ProductItemCard(
                  title: 'Product number $index with a long name',
                  price: '\$${(index + 1) * 10}',
                  index: index,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _ProductItemCard extends StatelessWidget {
  final String title;
  final String price;
  final int index;

  const _ProductItemCard({
    required this.title,
    required this.price,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final iconList = [
      Icons.inventory_2_outlined,
      Icons.headphones_outlined,
      Icons.watch_outlined,
      Icons.shopping_bag_outlined,
    ];
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = (screenWidth * 0.03).clamp(12.0, 16.0);
    final priceFontSize = (screenWidth * 0.035).clamp(14.0, 18.0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Icon(
                iconList[index % iconList.length],
                size: 42,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: priceFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }
}
