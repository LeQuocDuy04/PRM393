import 'package:flutter/material.dart';

import 'guards/auth_guard.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'services/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loggedIn = await SessionService.isLoggedIn();
  runApp(AuthSessionApp(initialLoggedIn: loggedIn));
}

class AuthSessionApp extends StatelessWidget {
  final bool initialLoggedIn;

  const AuthSessionApp({super.key, required this.initialLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Session Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: initialLoggedIn ? '/dashboard' : '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const LoginScreen(),
            );
          case '/dashboard':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => AuthGuard.protect(
                child: const DashboardScreen(),
              ),
            );
          case '/profile':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => AuthGuard.protect(
                child: const ProfileScreen(),
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('404 - Route not found')),
              ),
            );
        }
      },
    );
  }
}
