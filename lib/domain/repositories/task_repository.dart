import 'package:todo/domain/entities/task.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> updateTask(Task task);
  Future<List<Task>> getTasksByCategoryId(String categoryId);
}
