import 'package:flutter/material.dart';

import '../services/session_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _openProfile(BuildContext context) async {
    final loggedIn = await SessionService.isLoggedIn();
    if (!context.mounted) return;

    if (!loggedIn) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    Navigator.pushNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.dashboard_outlined, size: 72),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Dashboard',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _openProfile(context),
              icon: const Icon(Icons.person),
              label: const Text('Open Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
