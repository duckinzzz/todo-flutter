import 'package:flutter/material.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/task.dart';
import 'package:uuid/uuid.dart';

class TaskListScreen extends StatefulWidget {
  final Category category;
  final List<Task> allTasks;

  const TaskListScreen({required this.category, required this.allTasks});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> filteredTasks = [];
  String filter = 'Все';

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

  void applyFilter() {
    setState(() {
      filteredTasks = widget.allTasks
          .where((task) => task.categoryId == widget.category.id)
          .toList();

      if (filter == 'Завершенные') {
        filteredTasks =
            filteredTasks.where((task) => task.isCompleted).toList();
      } else if (filter == 'Незавершенные') {
        filteredTasks =
            filteredTasks.where((task) => !task.isCompleted).toList();
      } else if (filter == 'Избранные') {
        filteredTasks =
            filteredTasks.where((task) => task.isFavourite).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                filter = result;
                applyFilter();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Все',
                child: Text('Все'),
              ),
              const PopupMenuItem<String>(
                value: 'Завершенные',
                child: Text('Завершенные'),
              ),
              const PopupMenuItem<String>(
                value: 'Незавершенные',
                child: Text('Незавершенные'),
              ),
              const PopupMenuItem<String>(
                value: 'Избранные',
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
                    icon:
                        Icon(task.isFavourite ? Icons.star : Icons.star_border),
                    onPressed: () => toggleFavourite(task.id),
                  ),
                ],
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

  const AddTaskDialog({required this.categoryId});

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
