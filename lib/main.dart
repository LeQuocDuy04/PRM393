import 'package:flutter/material.dart';

import 'screens/future_product_screen.dart';
import 'screens/stream_counter_screen.dart';

void main() {
  runApp(const Slot4App());
}

class Slot4App extends StatelessWidget {
  const Slot4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slot 4 - Async Dart & Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const Slot4HomePage(),
    );
  }
}

class Slot4HomePage extends StatefulWidget {
  const Slot4HomePage({super.key});

  @override
  State<Slot4HomePage> createState() => _Slot4HomePageState();
}

class _Slot4HomePageState extends State<Slot4HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    FutureProductScreen(),
    StreamCounterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Future Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            selectedIcon: Icon(Icons.multiline_chart),
            label: 'Stream Counter',
          ),
        ],
      ),
    );
  }
}
