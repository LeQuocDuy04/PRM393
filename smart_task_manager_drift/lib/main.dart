import 'package:flutter/material.dart';
import 'db/app_database.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SmartTaskManagerApp(database: AppDatabase()));
}

class SmartTaskManagerApp extends StatefulWidget {
  const SmartTaskManagerApp({super.key, required this.database});
  final AppDatabase database;

  @override
  State<SmartTaskManagerApp> createState() => _SmartTaskManagerAppState();
}

class _SmartTaskManagerAppState extends State<SmartTaskManagerApp> {
  @override
  void dispose() {
    widget.database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Smart Task Manager Drift',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(database: widget.database),
      );
}
