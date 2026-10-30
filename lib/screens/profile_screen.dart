import 'package:flutter/material.dart';

import '../guards/auth_guard.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.authService, super.key});

  final AuthService authService;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<bool> _accessCheck;

  @override
  void initState() {
    super.initState();
    _accessCheck = AuthGuard.canOpenProfile(widget.authService);
  }

  Future<void> _logout() async {
    await widget.authService.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _accessCheck,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data != true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            }
          });
          return const Scaffold(
            body: Center(child: Text('Redirecting to Login...')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Center(
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      child: Icon(Icons.person, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'User Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('Username: admin'),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      key: const Key('logoutButton'),
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
