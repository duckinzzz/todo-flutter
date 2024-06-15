import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo/domain/entities/category.dart';
import 'package:todo/domain/entities/task.dart';
import 'package:todo/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:todo/presentation/screens/task_detail_screen.dart';

class TaskListScreen extends StatelessWidget {
  final Category category;

  const TaskListScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<TaskCubit>(),
      child: TaskListView(category: category),
    );
  }
}

class TaskListView extends StatefulWidget {
  final Category category;

  const TaskListView({Key? key, required this.category}) : super(key: key);

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

enum TaskFilter { all, completed, incomplete, favourite }

class _TaskListViewState extends State<TaskListView> {
  TaskFilter filter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
  }

  void addTask(Task task) {
    context.read<TaskCubit>().addTask(task);
  }

  void deleteTask(String taskId) {
    context.read<TaskCubit>().deleteTask(taskId);
  }

  void toggleCompleted(String taskId) {
    final task = context.read<TaskCubit>().state.tasks.firstWhere((task) => task.id == taskId);
    task.isCompleted = !task.isCompleted;
    context.read<TaskCubit>().updateTask(task);
  }

  void toggleFavourite(String taskId) {
    final task = context.read<TaskCubit>().state.tasks.firstWhere((task) => task.id == taskId);
    task.isFavourite = !task.isFavourite;
    context.read<TaskCubit>().updateTask(task);
  }

  List<Task> applyFilter(TaskState state) {
    final tasks = state.tasks.where((task) => task.categoryId == widget.category.id).toList();
    switch (filter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.incomplete:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.favourite:
        return tasks.where((task) => task.isFavourite).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          PopupMenuButton<TaskFilter>(
            onSelected: (TaskFilter selectedFilter) {
              setState(() {
                filter = selectedFilter;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskFilter>>[
              const PopupMenuItem<TaskFilter>(
                value: TaskFilter.all,
                child: Text('Все'),
              ),
              const PopupMenuItem<TaskFilter>(
                value: TaskFilter.completed,
                child: Text('Завершенные'),
              ),
              const PopupMenuItem<TaskFilter>(
                value: TaskFilter.incomplete,
                child: Text('Незавершенные'),
              ),
              const PopupMenuItem<TaskFilter>(
                value: TaskFilter.favourite,
                child: Text('Избранные'),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          final filteredTasks = applyFilter(state);
          return ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return Dismissible(
                key: Key(task.id),
                onDismissed: (direction) {
                  deleteTask(task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${task.title} deleted')),
                  );
                  setState(() {
                    filteredTasks.removeAt(index);
                  });
                },
                background: Container(color: Colors.red),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(
                          task: task,
                          taskCubit: context.read<TaskCubit>(),
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(task.title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(task.isCompleted
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                          onPressed: () => toggleCompleted(task.id),
                        ),
                        IconButton(
                          icon: Icon(
                              task.isFavourite ? Icons.star : Icons.star_border),
                          onPressed: () => toggleFavourite(task.id),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await showDialog<Task?>(
            context: context,
            builder: (context) => AddTaskDialog(categoryId: widget.category.id),
          );
          if (newTask != null) {
            addTask(newTask);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  final String categoryId;

  const AddTaskDialog({super.key, required this.categoryId});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить задачу'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Название'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите название задачи';
                }
                return null;
              },
              onSaved: (value) {
                title = value ?? '';
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Описание'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите описание задачи';
                }
                return null;
              },
              onSaved: (value) {
                description = value ?? '';
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newTask = Task(
                id: const Uuid().v4(),
                title: title,
                description: description,
                categoryId: widget.categoryId,
                createdAt: DateTime.now(),
              );
              Navigator.of(context).pop(newTask);
            }
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
