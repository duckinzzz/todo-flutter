import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/entities/task.dart';
import 'package:todo/domain/usecases/add_task.dart';
import 'package:todo/domain/usecases/delete_task.dart';
import 'package:todo/domain/usecases/update_task.dart';

enum Status { initial, loading, loaded, error }

class TaskState extends Equatable {
  final List<Task> tasks;
  final Status status;
  final String? errorMessage;

  const TaskState({
    required this.tasks,
    this.status = Status.initial,
    this.errorMessage,
  });

  TaskState copyWith({
    List<Task>? tasks,
    Status? status,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [tasks, status, errorMessage];
}

class TaskCubit extends Cubit<TaskState> {
  final AddTask addTaskUseCase;
  final DeleteTask deleteTaskUseCase;
  final UpdateTask updateTaskUseCase;

  TaskCubit({
    required this.addTaskUseCase,
    required this.deleteTaskUseCase,
    required this.updateTaskUseCase,
  }) : super(const TaskState(tasks: []));

  void addTask(Task task) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await addTaskUseCase(task);
      emit(state.copyWith(
        status: Status.loaded,
        tasks: [...state.tasks, task],
      ));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  void deleteTask(String id) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await deleteTaskUseCase(id);
      emit(state.copyWith(
        status: Status.loaded,
        tasks: state.tasks.where((task) => task.id != id).toList(),
      ));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }

  void updateTask(Task task) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await updateTaskUseCase(task);
      emit(state.copyWith(
        status: Status.loaded,
        tasks: [
          for (final t in state.tasks) t.id == task.id ? task : t,
        ],
      ));
    } catch (e) {
      emit(state.copyWith(status: Status.error, errorMessage: e.toString()));
    }
  }
}
