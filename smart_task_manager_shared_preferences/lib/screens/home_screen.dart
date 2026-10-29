import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/preferences_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = PreferencesService();
  final _addController = TextEditingController();
  List<Task> _tasks = [];
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _service.loadTasks();
      if (!mounted) return;
      setState(() {
        _tasks = tasks;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Không thể tải task: $e';
      });
    }
  }

  Future<void> _persist(List<Task> next) async {
    setState(() {
      _tasks = next;
      _saving = true;
      _error = null;
    });
    try {
      await _service.saveTasks(next);
    } catch (e) {
      if (mounted) setState(() => _error = 'Không thể lưu dữ liệu: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _addTask() async {
    final title = _addController.text.trim();
    if (title.isEmpty) {
      _message('Vui lòng nhập tiêu đề task.');
      return;
    }
    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
    );
    _addController.clear();
    await _persist([task, ..._tasks]);
  }

  Future<void> _toggleTask(Task task, bool value) async {
    await _persist([
      for (final item in _tasks)
        if (item.id == task.id) item.copyWith(isDone: value) else item,
    ]);
  }

  Future<void> _deleteTask(Task task) async {
    await _persist(_tasks.where((item) => item.id != task.id).toList());
  }

  Future<void> _editTask(Task task) async {
    final controller = TextEditingController(text: task.title);
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 120,
          decoration: const InputDecoration(labelText: 'Tiêu đề mới'),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (title == null) return;
    if (title.trim().isEmpty) {
      _message('Tiêu đề không được để trống.');
      return;
    }
    await _persist([
      for (final item in _tasks)
        if (item.id == task.id) item.copyWith(title: title.trim()) else item,
    ]);
  }

  Future<void> _clearAll() async {
    if (_tasks.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tất cả task?'),
        content: const Text('Thao tác này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _service.clearTasks();
      if (mounted) await _persist([]);
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final completed = _tasks.where((task) => task.isDone).length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Task Manager'),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          IconButton(
            tooltip: 'Xóa tất cả',
            onPressed: _clearAll,
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$completed/${_tasks.length} task hoàn thành',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _addController,
                              maxLength: 120,
                              decoration: const InputDecoration(
                                labelText: 'Nhập task mới',
                                counterText: '',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (_) => _addTask(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: _addTask,
                            child: const Text('Thêm'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_error != null)
                  MaterialBanner(
                    content: Text(_error!),
                    actions: [
                      TextButton(
                        onPressed: _loadTasks,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                const Divider(height: 1),
                Expanded(
                  child: _tasks.isEmpty
                      ? const Center(
                          child: Text('Chưa có task. Hãy thêm task đầu tiên!'),
                        )
                      : ListView.separated(
                          itemCount: _tasks.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final task = _tasks[index];
                            return ListTile(
                              leading: Checkbox(
                                value: task.isDone,
                                onChanged: (value) {
                                  if (value != null) _toggleTask(task, value);
                                },
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: task.isDone
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                      : null,
                                ),
                              ),
                              subtitle:
                                  Text(task.isDone ? 'Đã hoàn thành' : 'Chưa hoàn thành'),
                              onTap: () => _editTask(task),
                              trailing: IconButton(
                                tooltip: 'Xóa task',
                                onPressed: () => _deleteTask(task),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
