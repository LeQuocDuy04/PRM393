import 'package:flutter/material.dart';

import '../models/student.dart';
import '../widgets/student_card.dart';
import 'student_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Student> students = [
    Student(
      id: 'SV01',
      name: 'Nguyễn Văn A',
      email: 'a@student.edu',
      major: 'Computer Science',
    ),
    Student(
      id: 'SV02',
      name: 'Trần Thị B',
      email: 'b@student.edu',
      major: 'Information Systems',
    ),
    Student(
      id: 'SV03',
      name: 'Lê Văn C',
      email: 'c@student.edu',
      major: 'Software Engineering',
    ),
    Student(
      id: 'SV04',
      name: 'Phạm Văn D',
      email: 'd@student.edu',
      major: 'Data Science',
    ),
    Student(
      id: 'SV05',
      name: 'Hoàng Thị E',
      email: 'e@student.edu',
      major: 'Cybersecurity',
    ),
    Student(
      id: 'SV06',
      name: 'Đỗ Minh F',
      email: 'f@student.edu',
      major: 'Artificial Intelligence',
    ),
  ];

  int get selectedCount => students.where((student) => student.isSelected).length;

  void _toggleSelected(Student student) {
    setState(() {
      student.isSelected = !student.isSelected;
    });
  }

  void _openDetail(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => StudentDetailScreen(student: student),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$selectedCount selected',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.groups_rounded,
                    size: 34, color: Color(0xFF3157A4)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Student directory',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('${students.length} students • Tap a student to view details'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return StudentCard(
                  student: student,
                  onSelect: () => _toggleSelected(student),
                  onOpenDetail: () => _openDetail(student),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final message = selectedCount == 0
              ? 'Chưa có sinh viên nào được chọn.'
              : 'Bạn đã chọn $selectedCount/${students.length} sinh viên.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        icon: const Icon(Icons.checklist),
        label: const Text('Selection summary'),
      ),
    );
  }
}
