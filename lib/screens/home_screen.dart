import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Manager')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.school, size: 88),
              const SizedBox(height: 16),
              Text('Quản lý sinh viên', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text('Ví dụ Named Routes, Arguments và Deep Linking', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.studentList),
                  icon: const Icon(Icons.people),
                  label: const Text('Xem danh sách sinh viên'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
