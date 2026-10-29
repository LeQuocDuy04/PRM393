import 'package:drift/drift.dart';
import '../db/app_database.dart';

class TaskDao {
  final AppDatabase db;
  TaskDao(this.db);

  Stream<List<Task>> watchAllTasks() {
    return (db.select(db.tasks)
          ..orderBy([(task) => OrderingTerm.desc(task.createdAt)]))
        .watch();
  }

  Future<void> insertTask(String title) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.into(db.tasks).insert(
          TasksCompanion.insert(
            id: now.toString(),
            title: title,
            createdAt: now,
          ),
        );
  }

  Future<void> toggleTask(Task task) async {
    await (db.update(db.tasks)..where((row) => row.id.equals(task.id))).write(
      TasksCompanion(isDone: Value(!task.isDone)),
    );
  }

  Future<void> updateTitle(Task task, String title) async {
    await (db.update(db.tasks)..where((row) => row.id.equals(task.id))).write(
      TasksCompanion(title: Value(title)),
    );
  }

  Future<void> deleteTask(Task task) async {
    await (db.delete(db.tasks)..where((row) => row.id.equals(task.id))).go();
  }

  Future<void> deleteAll() async {
    await db.delete(db.tasks).go();
  }
}
