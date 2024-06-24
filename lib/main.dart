import 'package:flutter/material.dart';
import 'package:todo/presentation/screens/category_list_screen.dart';
import 'package:todo/core/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:todo/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:todo/presentation/blocs/category_bloc/category_bloc.dart';

void main() {
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CategoryCubit>(
          create: (_) => sl<CategoryCubit>(),
        ),
        Provider<TaskCubit>(
          create: (_) => sl<TaskCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CategoryListScreen(),
      ),
    );
  }
}
