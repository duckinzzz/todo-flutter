import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class CategoryTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class TaskTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().withLength(min: 1, max: 255)();
  TextColumn get categoryId => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavourite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Category {
  final String id;
  final String name;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
  });
}

class Task {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final bool isCompleted;
  final bool isFavourite;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.isCompleted,
    required this.isFavourite,
    required this.createdAt,
  });
}

@DriftDatabase(tables: [CategoryTable, TaskTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Category>> getAllCategories() => select(categoryTable).map((row) => Category(
    id: row.id,
    name: row.name,
    createdAt: row.createdAt,
  )).get();

  Future<void> insertCategory(Category category) => into(categoryTable).insert(CategoryTableCompanion(
    id: Value(category.id),
    name: Value(category.name),
    createdAt: Value(category.createdAt),
  ));

  Future<void> deleteCategory(Category category) => (delete(categoryTable)..where((tbl) => tbl.id.equals(category.id))).go();

  Future<List<Task>> getTasksByCategoryId(String categoryId) =>
      (select(taskTable)..where((t) => t.categoryId.equals(categoryId))).map((row) => Task(
        id: row.id,
        title: row.title,
        description: row.description,
        categoryId: row.categoryId,
        isCompleted: row.isCompleted,
        isFavourite: row.isFavourite,
        createdAt: row.createdAt,
      )).get();

  Future<void> insertTask(Task task) => into(taskTable).insert(TaskTableCompanion(
    id: Value(task.id),
    title: Value(task.title),
    description: Value(task.description),
    categoryId: Value(task.categoryId),
    isCompleted: Value(task.isCompleted),
    isFavourite: Value(task.isFavourite),
    createdAt: Value(task.createdAt),
  ));

  Future<void> deleteTask(Task task) => (delete(taskTable)..where((tbl) => tbl.id.equals(task.id))).go();

  Future<void> updateTask(Task task) => update(taskTable).replace(TaskTableCompanion(
    id: Value(task.id),
    title: Value(task.title),
    description: Value(task.description),
    categoryId: Value(task.categoryId),
    isCompleted: Value(task.isCompleted),
    isFavourite: Value(task.isFavourite),
    createdAt: Value(task.createdAt),
  ));
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
