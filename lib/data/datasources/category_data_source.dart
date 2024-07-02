import 'package:todo/data/models/category_model.dart';
import 'package:todo/data/datasources/database.dart';

abstract class CategoryDataSource {
  Future<void> addCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
  Future<List<CategoryModel>> getCategories();
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final AppDatabase database;

  CategoryDataSourceImpl(this.database);

  @override
  Future<void> addCategory(CategoryModel category) async {
    await database.insertCategory(category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await database.deleteCategory(CategoryModel(id: id, name: '', createdAt: DateTime.now()));
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    return await database.getAllCategories();
  }
}
