import 'package:todo/data/datasources/task_data_source.dart';
import 'package:todo/domain/entities/task.dart';
import 'package:todo/domain/repositories/task_repository.dart';
import 'package:todo/data/models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource dataSource;

  const TaskRepositoryImpl(this.dataSource);

  @override
  Future<void> addTask(Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      categoryId: task.categoryId,
      isCompleted: task.isCompleted,
      isFavourite: task.isFavourite,
      createdAt: task.createdAt,
    );
    await dataSource.addTask(taskModel);
  }

  @override
  Future<void> deleteTask(String id) async {
    await dataSource.deleteTask(id);
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      categoryId: task.categoryId,
      isCompleted: task.isCompleted,
      isFavourite: task.isFavourite,
      createdAt: task.createdAt,
    );
    await dataSource.updateTask(taskModel);
  }

  @override
  Future<List<Task>> getTasksByCategoryId(String categoryId) async {
    final tasks = await dataSource.getTasksByCategoryId(categoryId);
    return tasks.map((taskModel) => Task(
      id: taskModel.id,
      title: taskModel.title,
      description: taskModel.description,
      categoryId: taskModel.categoryId,
      isCompleted: taskModel.isCompleted,
      isFavourite: taskModel.isFavourite,
      createdAt: taskModel.createdAt,
    )).toList();
  }
}
