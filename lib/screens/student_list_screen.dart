import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/student_store.dart';
import '../routes/app_routes.dart';
import '../widgets/student_tile.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentStore _store = StudentStore.instance;

  Future<void> _openDetail(Student student) async {
    final result = await Navigator.pushNamed<Object?>(
      context,
      AppRoutes.studentDetail,
      arguments: student,
    );
    if (!mounted) return;
    if (result is Student) {
      setState(() => _store.update(result));
    }
  }

  Future<void> _openForm() async {
    final result = await Navigator.push<Student>(
      context,
      MaterialPageRoute(builder: (_) => const StudentFormScreen()),
    );
    if (!mounted || result == null) return;
    setState(() => _store.add(result));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm sinh viên ${result.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final students = _store.students;
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách sinh viên (${students.length})')),
      body: students.isEmpty
          ? const Center(child: Text('Chưa có sinh viên. Nhấn + để thêm.'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return StudentTile(student: student, onTap: () => _openDetail(student));
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.add),
        label: const Text('Thêm sinh viên'),
      ),
    );
  }
}
