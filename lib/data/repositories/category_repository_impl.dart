import 'package:todo/data/datasources/category_data_source.dart';
import 'package:todo/domain/entities/category.dart';
import 'package:todo/domain/repositories/category_repository.dart';
import 'package:todo/data/models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource dataSource;

  const CategoryRepositoryImpl(this.dataSource);

  @override
  Future<void> addCategory(Category category) async {
    final categoryModel = CategoryModel(
      id: category.id,
      name: category.name,
      createdAt: category.createdAt,
    );
    await dataSource.addCategory(categoryModel);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await dataSource.deleteCategory(id);
  }

  @override
  Future<List<Category>> getCategories() async {
    final categories = await dataSource.getCategories();
    return categories.map((categoryModel) => Category(
      id: categoryModel.id,
      name: categoryModel.name,
      createdAt: categoryModel.createdAt,
    )).toList();
  }
}
