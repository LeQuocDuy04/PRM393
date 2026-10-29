import 'package:flutter/material.dart';
import '../db/app_database.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _repository = TaskRepository(AppDatabase.instance);
  List<Task> _tasks = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final result = await _repository.getAll();
      if (!mounted) return;
      setState(() {
        _tasks = result;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Không thể đọc database: $e';
      });
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
      await _loadTasks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Thao tác thất bại: $e')));
      }
    }
  }

  Future<void> _add() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    await _run(() async {
      await _repository.add(title);
      _controller.clear();
    });
  }

  Future<void> _edit(Task task) async {
    final controller = TextEditingController(text: task.title);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Tiêu đề mới'),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Lưu')),
        ],
      ),
    );
    controller.dispose();
    if (value == null || value.trim().isEmpty) return;
    await _run(() => _repository.updateTitle(task, value.trim()));
  }

  Future<void> _clearAll() async {
    if (_tasks.isEmpty) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tất cả task?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );
    if (yes == true) await _run(_repository.deleteAll);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Smart Task Manager · SQLite'),
          actions: [IconButton(onPressed: _clearAll, icon: const Icon(Icons.delete_sweep))],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: 'Nhập task mới',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) => _add(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(onPressed: _add, child: const Text('Thêm')),
                      ],
                    ),
                  ),
                  if (_error != null)
                    ListTile(
                      leading: const Icon(Icons.error_outline),
                      title: Text(_error!),
                      trailing: TextButton(onPressed: _loadTasks, child: const Text('Thử lại')),
                    ),
                  Expanded(
                    child: _tasks.isEmpty
                        ? const Center(child: Text('Chưa có task nào.'))
                        : ListView.separated(
                            itemCount: _tasks.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final task = _tasks[index];
                              return ListTile(
                                leading: Checkbox(
                                  value: task.isDone,
                                  onChanged: (_) => _run(() => _repository.toggle(task)),
                                ),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                                onTap: () => _edit(task),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _run(() => _repository.delete(task)),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      );
}
