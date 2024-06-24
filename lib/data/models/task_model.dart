import 'package:todo/domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required String id,
    required String title,
    required String description,
    required String categoryId,
    required bool isCompleted,
    required bool isFavourite,
    required DateTime createdAt,
  }) : super(
    id: id,
    title: title,
    description: description,
    categoryId: categoryId,
    isCompleted: isCompleted,
    isFavourite: isFavourite,
    createdAt: createdAt,
  );

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      categoryId: task.categoryId,
      isCompleted: task.isCompleted,
      isFavourite: task.isFavourite,
      createdAt: task.createdAt,
    );
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      categoryId: categoryId,
      isCompleted: isCompleted,
      isFavourite: isFavourite,
      createdAt: createdAt,
    );
  }
}
