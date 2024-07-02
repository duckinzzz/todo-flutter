import 'package:todo/data/models/task_model.dart';
import 'package:todo/data/datasources/database.dart';

abstract class TaskDataSource {
  Future<void> addTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> updateTask(TaskModel task);
  Future<List<TaskModel>> getTasksByCategoryId(String categoryId);
}

class TaskDataSourceImpl implements TaskDataSource {
  final AppDatabase database;

  TaskDataSourceImpl(this.database);

  @override
  Future<void> addTask(TaskModel task) async {
    await database.insertTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await database.deleteTask(TaskModel(
      id: id,
      title: '',
      description: '',
      categoryId: '',
      isCompleted: false,
      isFavourite: false,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await database.updateTask(task);
  }

  @override
  Future<List<TaskModel>> getTasksByCategoryId(String categoryId) async {
    return await database.getTasksByCategoryId(categoryId);
  }
}
