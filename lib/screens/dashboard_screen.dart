import 'package:flutter/material.dart';

import '../widgets/dashboard_header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w800))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),
              const SizedBox(height: 28),
              const Text('Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              const Text('A quick look at your product store.', style: TextStyle(color: Color(0xFF737B8C))),
              const SizedBox(height: 18),
              Row(
                children: const [
                  Expanded(child: _SummaryCard(title: 'Products', value: '24', icon: Icons.inventory_2_outlined, tint: Color(0xFFE0E7FF), iconColor: Color(0xFF4338CA))),
                  SizedBox(width: 12),
                  Expanded(child: _SummaryCard(title: 'Orders', value: '08', icon: Icons.shopping_bag_outlined, tint: Color(0xFFD1FAE5), iconColor: Color(0xFF047857))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(child: _SummaryCard(title: 'Revenue', value: '\$540', icon: Icons.payments_outlined, tint: Color(0xFFFEF3C7), iconColor: Color(0xFFB45309))),
                  SizedBox(width: 12),
                  Expanded(child: _SummaryCard(title: 'Messages', value: '03', icon: Icons.chat_bubble_outline_rounded, tint: Color(0xFFFCE7F3), iconColor: Color(0xFFBE185D))),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Explore your catalog', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                        SizedBox(height: 6),
                        Text('Browse products and their prices.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ]),
                    ),
                    Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 32),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/products'),
                  icon: const Icon(Icons.grid_view_rounded),
                  label: const Text('Xem danh sách sản phẩm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.value, required this.icon, required this.tint, required this.iconColor});

  final String title;
  final String value;
  final IconData icon;
  final Color tint;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor)),
        const SizedBox(height: 13),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF737B8C))),
      ]),
    );
  }
}
