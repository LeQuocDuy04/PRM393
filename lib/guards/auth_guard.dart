import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../services/session_service.dart';

class AuthGuard {
  static Widget protect({required Widget child}) {
    return FutureBuilder<bool>(
      future: SessionService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data != true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            }
          });

          return const Scaffold(
            body: Center(child: Text('Redirecting to Login...')),
          );
        }

        return child;
      },
    );
  }

  // Reusable check for actions that need to verify the session.
  static Future<bool> check() => SessionService.isLoggedIn();
}
