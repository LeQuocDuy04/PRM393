import 'package:flutter_test/flutter_test.dart';
import 'package:todo_backup_app/models/todo.dart';
import 'package:todo_backup_app/services/json_service.dart';

void main() {
  group('Todo JSON model', () {
    test('toJson and fromJson preserve todo values', () {
      final todo = Todo(title: 'Study Flutter', done: true);
      final restored = Todo.fromJson(todo.toJson());

      expect(restored.title, 'Study Flutter');
      expect(restored.done, isTrue);
    });

    test('fromJson rejects invalid values', () {
      expect(
        () => Todo.fromJson({'title': 10, 'done': false}),
        throwsFormatException,
      );
    });
  });

  group('JsonService', () {
    const service = JsonService();

    test('exports list of todos as JSON', () {
      final json = service.exportTodos([
        Todo(title: 'Buy milk'),
        Todo(title: 'Study Flutter', done: true),
      ]);

      expect(json, contains('"title": "Buy milk"'));
      expect(json, contains('"done": true'));
    });

    test('imports a valid JSON list', () {
      final todos = service.importTodos(
        '[{"title":"Task A","done":false},{"title":"Task B","done":true}]',
      );

      expect(todos, hasLength(2));
      expect(todos[0].title, 'Task A');
      expect(todos[1].done, isTrue);
    });

    test('rejects a non-list JSON structure', () {
      expect(
        () => service.importTodos('{"title":"not a list"}'),
        throwsFormatException,
      );
    });
  });
}
