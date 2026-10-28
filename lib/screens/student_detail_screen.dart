import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/student_store.dart';
import '../routes/app_routes.dart';
import 'student_form_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({super.key});

  Future<void> _editStudent(BuildContext context, Student student) async {
    final updated = await Navigator.push<Student>(
      context,
      MaterialPageRoute(builder: (_) => StudentFormScreen(student: student)),
    );
    if (context.mounted && updated != null) {
      StudentStore.instance.update(updated);
      Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Student) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết sinh viên')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('Không tìm thấy dữ liệu sinh viên. Hãy mở chi tiết từ danh sách hoặc dùng deep link có mã hợp lệ.', textAlign: TextAlign.center),
          ),
        ),
      );
    }
    final student = args;
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sinh viên')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 44)),
            const SizedBox(height: 24),
            _InfoRow(label: 'Mã sinh viên', value: student.id),
            _InfoRow(label: 'Họ và tên', value: student.name),
            _InfoRow(label: 'Tuổi', value: '${student.age}'),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => _editStudent(context, student),
              icon: const Icon(Icons.edit),
              label: const Text('Chỉnh sửa sinh viên'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, student),
              child: const Text('Quay lại danh sách'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(title: Text(label), subtitle: Text(value, style: Theme.of(context).textTheme.titleMedium)),
      );
}
