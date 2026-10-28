import 'package:flutter/material.dart';

import '../models/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onSelect;
  final VoidCallback onOpenDetail;

  const StudentCard({
    super.key,
    required this.student,
    required this.onSelect,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final selected = student.isSelected;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onOpenDetail,
        leading: CircleAvatar(
          backgroundColor: selected
              ? const Color(0xFFDCE8FF)
              : const Color(0xFFE8ECF4),
          foregroundColor: const Color(0xFF3157A4),
          child: Text(
            student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('${student.id} • ${student.major}'),
        ),
        trailing: IconButton(
          tooltip: selected ? 'Bỏ chọn sinh viên' : 'Chọn sinh viên',
          onPressed: onSelect,
          icon: Icon(
            selected ? Icons.check_circle : Icons.circle_outlined,
            color: selected ? Colors.green : Colors.grey,
          ),
        ),
      ),
    );
  }
}
