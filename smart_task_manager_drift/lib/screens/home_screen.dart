import 'package:flutter/material.dart';
import '../db/app_database.dart';
import '../repositories/task_dao.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.database});
  final AppDatabase database;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TaskDao _dao;
  final _controller = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _dao = TaskDao(widget.database);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _perform(Future<void> Function() action) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await action();
    } catch (e) {
      if (mounted) setState(() => _error = 'Thao tác thất bại: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _add() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    await _perform(() async {
      await _dao.insertTask(title);
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
    await _perform(() => _dao.updateTitle(task, value.trim()));
  }

  Future<void> _clearAll() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tất cả task?'),
        content: const Text('Thao tác này không thể hoàn tác.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );
    if (yes == true) await _perform(_dao.deleteAll);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Smart Task Manager · Drift + Stream'),
          actions: [
            if (_saving)
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            IconButton(onPressed: _clearAll, icon: const Icon(Icons.delete_sweep), tooltip: 'Xóa tất cả'),
          ],
        ),
        body: Column(
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
                  FilledButton(onPressed: _saving ? null : _add, child: const Text('Thêm')),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            Expanded(
              child: StreamBuilder<List<Task>>(
                stream: _dao.watchAllTasks(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Không thể đọc task: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final tasks = snapshot.data!;
                  if (tasks.isEmpty) {
                    return const Center(child: Text('Chưa có task nào.'));
                  }
                  final doneCount = tasks.where((task) => task.isDone).length;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('$doneCount/${tasks.length} task hoàn thành'),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: tasks.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return ListTile(
                              leading: Checkbox(
                                value: task.isDone,
                                onChanged: _saving ? null : (_) => _perform(() => _dao.toggleTask(task)),
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
                                onPressed: _saving ? null : () => _perform(() => _dao.deleteTask(task)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
}
