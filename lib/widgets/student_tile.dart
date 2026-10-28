import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentTile extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const StudentTile({super.key, required this.student, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text(student.name.isEmpty ? '?' : student.name[0])),
        title: Text(student.name),
        subtitle: Text('Mã: ${student.id}  •  Tuổi: ${student.age}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
