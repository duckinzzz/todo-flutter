import 'package:todo/data/models/task_model.dart';

class TaskDataSource {
  final List<TaskModel> tasks = [];

  void addTask(TaskModel task) {
    tasks.add(task);
  }

  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
  }

  void updateTask(TaskModel updatedTask) {
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
    }
  }

  List<TaskModel> getTasksByCategoryId(String categoryId) {
    return tasks.where((task) => task.categoryId == categoryId).toList();
  }
}
