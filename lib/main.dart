import 'package:flutter/material.dart';
import 'package:todo/presentation/screens/category_list_screen.dart';
import 'package:todo/core/service_locator.dart';

void main() {
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CategoryListScreen(),
    );
  }
}
