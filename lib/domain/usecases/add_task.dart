import 'package:todo/domain/entities/task.dart';
import 'package:todo/domain/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  void call(Task task) {
    repository.addTask(task);
  }
}
