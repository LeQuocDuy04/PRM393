import 'package:flutter/material.dart';
import '../services/student_service.dart';

class FunctionsScreen extends StatelessWidget {
  final StudentService service;
  const FunctionsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final defaultFormatted = service.formatStudents();
    final callbackFormatted = service.formatStudents(formatter: (student) => '${student.name.toUpperCase()} | GPA=${student.gpaLabel} | ${student.gpa >= 3.5 ? 'HIGH GPA' : 'REGULAR'}');
    final highGpa = service.filterByMinimumGpa(3.5);
    final mappedData = service.allStudents.map((student) => student.toMap()).toList();
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('Function Processor & Data Preparation', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 8),
      const Text('Màn hình này minh họa function có giá trị trả về, callback, anonymous function, List, map() và where().'),
      const SizedBox(height: 16),
      _Section(title: '1. Function trả về dữ liệu', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Số sinh viên: ${service.allStudents.length}'), Text('GPA trung bình: ${service.averageGpa.toStringAsFixed(2)}')])),
      _Section(title: '2. map() – định dạng danh sách', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: defaultFormatted.map((text) => Text('• $text')).toList())),
      _Section(title: '3. where() – GPA từ 3.5 trở lên', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: highGpa.map((student) => Text('• ${student.name}: ${student.gpaLabel}')).toList())),
      _Section(title: '4. Callback formatter', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: callbackFormatted.map((text) => Text('• $text')).toList())),
      _Section(title: '5. Chuyển Student thành Map', child: SelectableText(mappedData.toString())),
    ]);
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 12), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 8), child])));
}
