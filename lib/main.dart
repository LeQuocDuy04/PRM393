import 'package:flutter/material.dart';
import 'data/datasources/user_fake_datasource.dart';
import 'data/repositories/user_repository_impl.dart';
import 'screens/live_counter_screen.dart';
import 'screens/user_list_screen.dart';
import 'screens/reactive_counter_screen.dart';

void main() {
  runApp(const Slot5App());
}

class Slot5App extends StatelessWidget {
  const Slot5App({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = UserRepositoryImpl(UserFakeDataSource());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Slot 5 Practice',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4267B2)),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero),
      ),
      home: MainNavigation(repository: repository),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, required this.repository});
  final UserRepositoryImpl repository;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const LiveCounterScreen(),
      UserListScreen(repository: widget.repository),
      const ReactiveCounterScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.timer_outlined), selectedIcon: Icon(Icons.timer), label: 'Live Stream'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Repository'),
          NavigationDestination(icon: Icon(Icons.bolt_outlined), selectedIcon: Icon(Icons.bolt), label: 'Reactive UI'),
        ],
      ),
    );
  }
}
