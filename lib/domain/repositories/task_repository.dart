import 'package:todo/domain/entities/task.dart';

abstract class TaskRepository {
  void addTask(Task task);
  void deleteTask(String id);
  void updateTask(Task task);
  List<Task> getTasksByCategoryId(String categoryId);
}
