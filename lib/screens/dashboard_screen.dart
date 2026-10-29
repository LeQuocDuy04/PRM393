import 'package:flutter/material.dart';
import '../widgets/summary_card.dart';
import '../widgets/responsive_grid.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery is used at screen level for general spacing and typography.
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = (screenWidth * 0.04).clamp(12.0, 32.0);
    final headerFontSize = (screenWidth * 0.06).clamp(22.0, 34.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You are all caught up!')),
              );
            },
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 18,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DashboardHeader(fontSize: headerFontSize),
                  const SizedBox(height: 8),
                  Text(
                    'Here is what is happening with your store today.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.blueGrey.shade600,
                        ),
                  ),
                  const SizedBox(height: 24),
                  const _SummarySection(),
                  const SizedBox(height: 28),
                  const ResponsiveProductGrid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final double fontSize;

  const _DashboardHeader({required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Dashboard',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF172554),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.insights, color: Colors.blue),
        ),
      ],
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        final cards = const [
          SummaryCard(
            title: 'Revenue',
            value: '\$12,300',
            color: Colors.blue,
            icon: Icons.trending_up,
          ),
          SummaryCard(
            title: 'Orders',
            value: '320',
            color: Colors.green,
            icon: Icons.shopping_bag_outlined,
          ),
          SummaryCard(
            title: 'Customers',
            value: '89',
            color: Colors.purple,
            icon: Icons.people_outline,
          ),
        ];

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final card in cards)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: card,
                ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(child: cards[i]),
            ],
          ],
        );
      },
    );
  }
}
