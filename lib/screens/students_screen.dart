import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';

class StudentsScreen extends StatefulWidget {
  final StudentService service;
  const StudentsScreen({super.key, required this.service});
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  double minimumGpa = 0;

  Future<void> _addStudent() async {
    final nameController = TextEditingController();
    final gpaController = TextEditingController(text: '3.0');
    final result = await showDialog<Student>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add student'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: gpaController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'GPA (0–4)')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(onPressed: () {
            final name = nameController.text.trim();
            final gpa = double.tryParse(gpaController.text);
            if (name.isEmpty || gpa == null || gpa < 0 || gpa > 4) return;
            final nextId = widget.service.allStudents.fold<int>(0, (maxId, s) => s.id > maxId ? s.id : maxId) + 1;
            Navigator.pop(dialogContext, Student(id: nextId, name: name, gpa: gpa));
          }, child: const Text('Add')),
        ],
      ),
    );
    if (result != null) setState(() => widget.service.addStudent(result));
  }

  Future<void> _editGpa(Student student) async {
    final controller = TextEditingController(text: student.gpa.toString());
    final value = await showDialog<double>(context: context, builder: (dialogContext) => AlertDialog(
      title: Text('Update GPA: ${student.name}'),
      content: TextField(controller: controller, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'GPA (0–4)')),
      actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')), FilledButton(onPressed: () {
        final gpa = double.tryParse(controller.text);
        if (gpa == null || gpa < 0 || gpa > 4) return;
        Navigator.pop(dialogContext, gpa);
      }, child: const Text('Save'))],
    ));
    if (value != null) setState(() => widget.service.updateGpa(student.id, value));
  }

  @override
  Widget build(BuildContext context) {
    final students = widget.service.filterByMinimumGpa(minimumGpa);
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('Student Manager', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 8),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Total students: ${widget.service.allStudents.length}'),
        Text('Average GPA: ${widget.service.averageGpa.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        Text('Minimum GPA filter: ${minimumGpa.toStringAsFixed(1)}'),
        Slider(value: minimumGpa, min: 0, max: 4, divisions: 8, label: minimumGpa.toStringAsFixed(1), onChanged: (value) => setState(() => minimumGpa = value)),
      ]))),
      const SizedBox(height: 8),
      FilledButton.icon(onPressed: _addStudent, icon: const Icon(Icons.person_add), label: const Text('Add student')),
      const SizedBox(height: 8),
      if (students.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No students match this GPA filter.'))),
      ...students.map((student) => Card(child: ListTile(
        leading: CircleAvatar(child: Text(student.name.isNotEmpty ? student.name[0].toUpperCase() : '?')),
        title: Text(student.name), subtitle: Text('ID: ${student.id} • GPA: ${student.gpaLabel}'),
        trailing: IconButton(tooltip: 'Edit GPA', icon: const Icon(Icons.edit), onPressed: () => _editGpa(student)),
      ))),
    ]);
  }
}
