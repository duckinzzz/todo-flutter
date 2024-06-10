import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/entities/task.dart';
import 'package:todo/domain/usecases/add_task.dart';
import 'package:todo/domain/usecases/delete_task.dart';
import 'package:todo/domain/usecases/update_task.dart';

class TaskState {
  final List<Task> tasks;

  TaskState(this.tasks);
}

class TaskCubit extends Cubit<TaskState> {
  final AddTask addTaskUseCase;
  final DeleteTask deleteTaskUseCase;
  final UpdateTask updateTaskUseCase;

  TaskCubit(
      {required this.addTaskUseCase,
        required this.deleteTaskUseCase,
        required this.updateTaskUseCase})
      : super(TaskState([]));

  void addTask(Task task) {
    addTaskUseCase(task);
    emit(TaskState([...state.tasks, task]));
  }

  void deleteTask(String id) {
    deleteTaskUseCase(id);
    emit(TaskState(
        state.tasks.where((task) => task.id != id).toList()));
  }

  void updateTask(Task task) {
    updateTaskUseCase(task);
    emit(TaskState([
      for (final t in state.tasks) t.id == task.id ? task : t
    ]));
  }
}
