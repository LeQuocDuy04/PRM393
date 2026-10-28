import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/student_store.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;
  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;

  bool get _isEditing => widget.student != null;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.student?.id ?? '');
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _ageController = TextEditingController(text: widget.student?.age.toString() ?? '');
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) return;
    final id = _idController.text.trim();
    final name = _nameController.text.trim();
    final age = int.parse(_ageController.text.trim());
    final store = StudentStore.instance;
    if (store.containsId(id, exceptId: widget.student?.id)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mã sinh viên đã tồn tại.')));
      return;
    }
    Navigator.pop(context, Student(id: id, name: name, age: age));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Chỉnh sửa sinh viên' : 'Thêm sinh viên')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'Mã sinh viên', border: OutlineInputBorder(), prefixIcon: Icon(Icons.badge)),
              textCapitalization: TextCapitalization.characters,
              validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng nhập mã sinh viên' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Họ và tên', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
              validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng nhập họ tên' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tuổi', border: OutlineInputBorder(), prefixIcon: Icon(Icons.cake)),
              validator: (value) {
                final age = int.tryParse(value?.trim() ?? '');
                if (age == null || age < 1 || age > 120) return 'Tuổi phải là số từ 1 đến 120';
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('Lưu thông tin')),
          ],
        ),
      ),
    );
  }
}
