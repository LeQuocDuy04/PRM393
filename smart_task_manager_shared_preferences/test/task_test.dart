import 'package:flutter_test/flutter_test.dart';
import 'package:smart_task_manager_shared_preferences/models/task.dart';

void main() {
  test('Task JSON round trip preserves values', () {
    const task = Task(id: '1', title: 'Study Flutter', isDone: true);
    final restored = Task.fromJson(task.toJson());
    expect(restored.id, task.id);
    expect(restored.title, task.title);
    expect(restored.isDone, isTrue);
  });
}
