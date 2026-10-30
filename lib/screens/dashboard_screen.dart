import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({required this.authService, super.key});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.dashboard_rounded, size: 56),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to Dashboard',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('Your session is active.'),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/profile'),
                      icon: const Icon(Icons.person_outline),
                      label: const Text('Open Profile'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
