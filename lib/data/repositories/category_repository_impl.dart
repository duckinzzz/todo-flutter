import 'package:todo/data/datasources/database.dart' as db;
import 'package:todo/domain/entities/category.dart' as domain;
import 'package:todo/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final db.AppDatabase database;

  CategoryRepositoryImpl(this.database);

  @override
  Future<void> addCategory(domain.Category category) async {
    final dbCategory = db.Category(
      id: category.id,
      name: category.name,
      createdAt: category.createdAt,
    );
    await database.insertCategory(dbCategory);
  }

  @override
  Future<void> deleteCategory(String id) async {
    final dbCategory = db.Category(
      id: id,
      name: '',
      createdAt: DateTime.now(),
    );
    await database.deleteCategory(dbCategory);
  }

  @override
  Future<List<domain.Category>> getCategories() async {
    final categories = await database.getAllCategories();
    return categories.map((category) => domain.Category(
      id: category.id,
      name: category.name,
      createdAt: category.createdAt,
    )).toList();
  }
}
