import 'package:flutter/material.dart';
import 'data/sample_data.dart';
import 'models/student.dart';
import 'services/student_service.dart';
import 'services/product_service.dart';
import 'screens/functions_screen.dart';
import 'screens/students_screen.dart';
import 'screens/shop_screen.dart';

void main() => runApp(const Slot3App());

class Slot3App extends StatefulWidget {
  const Slot3App({super.key});

  @override
  State<Slot3App> createState() => _Slot3AppState();
}

class _Slot3AppState extends State<Slot3App> {
  late final StudentService studentService;
  late final ProductService productService;

  @override
  void initState() {
    super.initState();
    studentService = StudentService(sampleStudents);
    productService = ProductService(sampleProducts);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Slot 3 Exercises',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo), useMaterial3: true),
      home: HomePage(studentService: studentService, productService: productService),
    );
  }
}

class HomePage extends StatefulWidget {
  final StudentService studentService;
  final ProductService productService;
  const HomePage({super.key, required this.studentService, required this.productService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      StudentsScreen(service: widget.studentService),
      FunctionsScreen(service: widget.studentService),
      ShopScreen(service: widget.productService),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Slot 3 – Combined Exercises')),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Students'),
          NavigationDestination(icon: Icon(Icons.functions), label: 'Functions'),
          NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag), label: 'Quick Shop'),
        ],
      ),
    );
  }
}
