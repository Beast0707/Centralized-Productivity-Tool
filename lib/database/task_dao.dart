import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tables.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TaskDao extends DatabaseAccessor<AppDatabase>
    with _$TaskDaoMixin {
  TaskDao(AppDatabase db) : super(db);

  Future<List<Task>> getAllTasks() {
    return select(tasks).get();
  }

  Future<List<Task>> getTasksByDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    return (select(tasks)
      ..where(
            (t) =>
        t.date.isBiggerOrEqualValue(start.toIso8601String()) &
        t.date.isSmallerThanValue(end.toIso8601String()),
      ))
        .get();
  }

  Future<int> insertTask(TasksCompanion task) {
    return into(tasks).insert(task);
  }

  Future<bool> updateTask(TasksCompanion task) async {
    final rowsUpdated = await update(tasks).write(task);
    return rowsUpdated > 0;
  }

  Future<int> deleteTask(int id) {
    return (delete(tasks)..where((t) => t.id.equals(id))).go();
  }

  Future<int> toggleTaskCompletion(int id, bool isCompleted) {
    return (update(tasks)..where((t) => t.id.equals(id))).write(
      TasksCompanion(
        isCompleted: Value(isCompleted ? 1 : 0),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }
}