import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:todo/data/models/category_model.dart';
import 'package:todo/data/models/task_model.dart';

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

@DriftDatabase(tables: [CategoryTable, TaskTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<CategoryModel>> getAllCategories() => select(categoryTable).map((row) => CategoryModel(
    id: row.id,
    name: row.name,
    createdAt: row.createdAt,
  )).get();

  Future<void> insertCategory(CategoryModel category) => into(categoryTable).insert(CategoryTableCompanion(
    id: Value(category.id),
    name: Value(category.name),
    createdAt: Value(category.createdAt),
  ));

  Future<void> deleteCategory(CategoryModel category) => (delete(categoryTable)..where((tbl) => tbl.id.equals(category.id))).go();

  Future<List<TaskModel>> getTasksByCategoryId(String categoryId) =>
      (select(taskTable)..where((t) => t.categoryId.equals(categoryId))).map((row) => TaskModel(
        id: row.id,
        title: row.title,
        description: row.description,
        categoryId: row.categoryId,
        isCompleted: row.isCompleted,
        isFavourite: row.isFavourite,
        createdAt: row.createdAt,
      )).get();

  Future<void> insertTask(TaskModel task) => into(taskTable).insert(TaskTableCompanion(
    id: Value(task.id),
    title: Value(task.title),
    description: Value(task.description),
    categoryId: Value(task.categoryId),
    isCompleted: Value(task.isCompleted),
    isFavourite: Value(task.isFavourite),
    createdAt: Value(task.createdAt),
  ));

  Future<void> deleteTask(TaskModel task) => (delete(taskTable)..where((tbl) => tbl.id.equals(task.id))).go();

  Future<void> updateTask(TaskModel task) => update(taskTable).replace(TaskTableCompanion(
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
