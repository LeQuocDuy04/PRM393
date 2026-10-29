import 'package:flutter_test/flutter_test.dart';
import 'package:smart_task_manager_sqlite/models/task.dart';

void main() {
  test('Task maps SQLite integer boolean correctly', () {
    final task = Task.fromMap({
      'id': 4,
      'title': 'Test',
      'is_done': 1,
      'created_at': 123,
    });
    expect(task.isDone, isTrue);
    expect(task.toMap()['is_done'], 1);
  });
}
