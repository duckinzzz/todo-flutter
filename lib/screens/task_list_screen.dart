import 'package:flutter/material.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/task.dart';
import 'package:uuid/uuid.dart';
import 'package:todo/screens/task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final Category category;
  final List<Task> allTasks;

  const TaskListScreen(
      {super.key, required this.category, required this.allTasks});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

enum TaskFilter { all, completed, incomplete, favourite }

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> filteredTasks = [];
  TaskFilter filter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    applyFilter();
  }

  void addTask(Task task) {
    setState(() {
      widget.allTasks.add(task);
      applyFilter();
    });
  }

  void deleteTask(String taskId) {
    setState(() {
      widget.allTasks.removeWhere((task) => task.id == taskId);
      applyFilter();
    });
  }

  void toggleCompleted(String taskId) {
    setState(() {
      final task = widget.allTasks.firstWhere((task) => task.id == taskId);
      task.isCompleted = !task.isCompleted;
    });
  }

  void toggleFavourite(String taskId) {
    setState(() {
      final task = widget.allTasks.firstWhere((task) => task.id == taskId);
      task.isFavourite = !task.isFavourite;
    });
  }

  void onUpdate(Task updatedTask) {
    setState(() {
      final index =
          widget.allTasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        widget.allTasks[index] = updatedTask;
        applyFilter();
      }
    });
  }

  void onDelete(Task taskToDelete) {
    setState(() {
      widget.allTasks.removeWhere((task) => task.id == taskToDelete.id);
      applyFilter();
    });
  }

  void applyFilter() {
    setState(() {
      switch (filter) {
        case TaskFilter.all:
          filteredTasks = widget.allTasks
              .where((task) => task.categoryId == widget.category.id)
              .toList();
          break;
        case TaskFilter.completed:
          filteredTasks = widget.allTasks
              .where((task) =>
                  task.categoryId == widget.category.id && task.isCompleted)
              .toList();
          break;
        case TaskFilter.incomplete:
          filteredTasks = widget.allTasks
              .where((task) =>
                  task.categoryId == widget.category.id && !task.isCompleted)
              .toList();
          break;
        case TaskFilter.favourite:
          filteredTasks = widget.allTasks
              .where((task) =>
                  task.categoryId == widget.category.id && task.isFavourite)
              .toList();
          break;
      }
    });
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
                applyFilter();
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
      body: ListView.builder(
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
                      onUpdate: onUpdate,
                      onDelete: (task) {
                        onDelete(task);
                        Navigator.pop(context);
                      },
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await showDialog<Task>(
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
