import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/entities/category.dart';
import 'package:todo/presentation/blocs/category_bloc/category_bloc.dart';
import 'package:todo/presentation/screens/task_list_screen.dart';
import 'package:todo/core/service_locator.dart';
import 'package:uuid/uuid.dart';

class CategoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryCubit>(),
      child: CategoryListView(),
    );
  }
}

class CategoryListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          final categoryCubit = context.watch<CategoryCubit>();

          return ListView.builder(
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return Dismissible(
                key: Key(category.id),
                onDismissed: (direction) {
                  categoryCubit.deleteCategory(category.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${category.name} deleted')),
                  );
                },
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text(category.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TaskListScreen(category: category),
                      ),
                    );
                  },
                ),
              );
            },
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
            context.read<CategoryCubit>().addCategory(
                  Category(
                      id: const Uuid().v4(),
                      name: newCategoryName,
                      createdAt: DateTime.now()),
                );
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
