import 'package:todo/data/datasources/task_data_source.dart';
import 'package:todo/data/models/task_model.dart';
import 'package:todo/domain/entities/task.dart';
import 'package:todo/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource dataSource = TaskDataSource();

  @override
  void addTask(Task task) {
    dataSource.addTask(TaskModel.fromEntity(task));
  }

  @override
  void deleteTask(String id) {
    dataSource.deleteTask(id);
  }

  @override
  void updateTask(Task task) {
    dataSource.updateTask(TaskModel.fromEntity(task));
  }

  @override
  List<Task> getTasksByCategoryId(String categoryId) {
    return dataSource
        .getTasksByCategoryId(categoryId)
        .map((model) => model.toEntity())
        .toList();
  }
}
