import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/json_service.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> _todos = [];
  final TextEditingController _controller = TextEditingController();
  final JsonService _jsonService = const JsonService();

  void _addTodo() {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      _showMessage('Vui lòng nhập công việc trước khi thêm.');
      return;
    }

    setState(() {
      _todos.add(Todo(title: title));
    });
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].done = !_todos[index].done;
    });
  }

  void _exportJson() {
    final jsonData = _jsonService.exportTodos(_todos);
    debugPrint('===== TODO BACKUP JSON =====\n$jsonData\n============================');

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('JSON Backup'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              jsonData,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _importSampleJson() {
    const sample = '''
[
  {"title": "Mua sữa", "done": false},
  {"title": "Học Flutter", "done": true}
]
''';
    try {
      final imported = _jsonService.importTodos(sample);
      setState(() {
        _todos
          ..clear()
          ..addAll(imported);
      });
      _showMessage('Đã import ${imported.length} công việc mẫu.');
    } on FormatException catch (error) {
      _showMessage('JSON không hợp lệ: ${error.message}');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _todos.where((todo) => todo.done).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Backup App'),
        actions: [
          IconButton(
            tooltip: 'Import JSON mẫu',
            icon: const Icon(Icons.file_open_outlined),
            onPressed: _importSampleJson,
          ),
          IconButton(
            tooltip: 'Export JSON Backup',
            icon: const Icon(Icons.save_outlined),
            onPressed: _exportJson,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    maxLength: 120,
                    decoration: const InputDecoration(
                      hintText: 'Nhập công việc...',
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _addTodo,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Công việc: ${_todos.length}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                Text(
                  'Hoàn thành: $completedCount/${_todos.length}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _todos.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Chưa có công việc nào.\nHãy nhập công việc rồi nhấn +.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return TodoItem(
                        todo: todo,
                        onTap: () => _toggleTodo(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
