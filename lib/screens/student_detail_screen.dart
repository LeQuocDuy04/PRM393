import 'package:flutter/material.dart';

import '../models/student.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final selected = student.isSelected;

    return Scaffold(
      appBar: AppBar(title: const Text('Student Detail')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: const Color(0xFFDCE8FF),
                    foregroundColor: const Color(0xFF3157A4),
                    child: Text(
                      student.name.isNotEmpty
                          ? student.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    student.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(student.id, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Chip(
                    avatar: Icon(
                      selected ? Icons.check_circle : Icons.circle_outlined,
                      size: 18,
                    ),
                    label: Text(selected ? 'Selected' : 'Not selected'),
                    backgroundColor:
                        selected ? const Color(0xFFE0F4E8) : Colors.black12,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _DetailInfoTile(
            icon: Icons.email_outlined,
            label: 'Email',
            value: student.email,
          ),
          _DetailInfoTile(
            icon: Icons.school_outlined,
            label: 'Major',
            value: student.major,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to student list'),
          ),
        ],
      ),
    );
  }
}

class _DetailInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF3157A4)),
        title: Text(label, style: const TextStyle(color: Colors.grey)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
