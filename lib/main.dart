import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'services/auth_service.dart';
import 'services/session_service.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sessionService = SessionService();
  final authService = AuthService(sessionService: sessionService);
  final isLoggedIn = await authService.hasValidSession();

  runApp(
    AuthSessionDemoApp(
      authService: authService,
      initialLoggedIn: isLoggedIn,
    ),
  );
}

class AuthSessionDemoApp extends StatelessWidget {
  const AuthSessionDemoApp({
    required this.authService,
    required this.initialLoggedIn,
    super.key,
  });

  final AuthService authService;
  final bool initialLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Session Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: initialLoggedIn ? '/dashboard' : '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => LoginScreen(authService: authService),
            );
          case '/dashboard':
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => DashboardScreen(authService: authService),
            );
          case '/profile':
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => ProfileScreen(authService: authService),
            );
          default:
            return MaterialPageRoute<void>(
              builder: (_) => const _NotFoundScreen(),
            );
        }
      },
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('404 - Route not found')),
    );
  }
}
