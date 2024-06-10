import 'package:todo/domain/entities/task.dart';
import 'package:todo/domain/repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  void call(Task task) {
    repository.updateTask(task);
  }
}
