import 'package:flutter/material.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/task.dart';
import 'package:todo/screens/task_list_screen.dart';
import 'package:uuid/uuid.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final List<Category> categories = [];
  final List<Task> allTasks = [];

  void addCategory(String name) {
    setState(() {
      categories.add(Category(id: const Uuid().v4(), name: name, createdAt: DateTime.now()));
    });
  }

  void deleteCategory(String categoryId) {
    setState(() {
      categories.removeWhere((category) => category.id == categoryId);
      allTasks.removeWhere((task) => task.categoryId == categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Dismissible(
            key: Key(category.id),
            onDismissed: (direction) {
              deleteCategory(category.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${category.name} deleted')),
              );
            },
            background: Container(color: Colors.red),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(category.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskListScreen(
                      category: category,
                      allTasks: allTasks,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCategoryName = await showDialog<String>(
            context: context,
            builder: (context) => AddCategoryDialog(),
          );
          if (newCategoryName != null) {
            addCategory(newCategoryName);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddCategoryDialog extends StatefulWidget {
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить категорию'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(labelText: 'Название категории'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите название категории';
            }
            return null;
          },
          onSaved: (value) {
            name = value ?? '';
          },
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
              Navigator.of(context).pop(name);
            }
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
