import 'package:todo/data/datasources/database.dart' as db;
import 'package:todo/domain/entities/task.dart' as domain;
import 'package:todo/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final db.AppDatabase database;

  TaskRepositoryImpl(this.database);

  @override
  Future<void> addTask(domain.Task task) async {
    final dbTask = db.Task(
      id: task.id,
      title: task.title,
      description: task.description,
      categoryId: task.categoryId,
      isCompleted: task.isCompleted,
      isFavourite: task.isFavourite,
      createdAt: task.createdAt,
    );
    await database.insertTask(dbTask);
  }

  @override
  Future<void> deleteTask(String id) async {
    final dbTask = db.Task(
      id: id,
      title: '',
      description: '',
      categoryId: '',
      isCompleted: false,
      isFavourite: false,
      createdAt: DateTime.now(),
    );
    await database.deleteTask(dbTask);
  }

  @override
  Future<void> updateTask(domain.Task task) async {
    final dbTask = db.Task(
      id: task.id,
      title: task.title,
      description: task.description,
      categoryId: task.categoryId,
      isCompleted: task.isCompleted,
      isFavourite: task.isFavourite,
      createdAt: task.createdAt,
    );
    await database.updateTask(dbTask);
  }

  @override
  Future<List<domain.Task>> getTasksByCategoryId(String categoryId) async {
    final tasks = await database.getTasksByCategoryId(categoryId);
    return tasks.map((task) => domain.Task(
      id: task.id,
      title: task.title,
      description: task.description,
      categoryId: task.categoryId,
      isCompleted: task.isCompleted,
      isFavourite: task.isFavourite,
      createdAt: task.createdAt,
    )).toList();
  }
}
