import 'package:sqflite/sqflite.dart';
import '../db/app_database.dart';
import '../models/task.dart';

class TaskRepository {
  final AppDatabase _database;
  TaskRepository(this._database);

  Future<List<Task>> getAll() async {
    final db = await _database.database;
    final rows = await db.query('tasks', orderBy: 'created_at DESC');
    return rows.map((row) => Task.fromMap(row)).toList();
  }

  Future<int> add(String title) async {
    final db = await _database.database;
    return db.insert('tasks', {
      'title': title,
      'is_done': 0,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<void> toggle(Task task) async {
    final db = await _database.database;
    await db.update(
      'tasks',
      {'is_done': task.isDone ? 0 : 1},
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> updateTitle(Task task, String title) async {
    final db = await _database.database;
    await db.update(
      'tasks',
      {'title': title},
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> delete(Task task) async {
    final db = await _database.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteAll() async {
    final db = await _database.database;
    await db.delete('tasks');
  }
}
