import 'package:todo/data/datasources/category_data_source.dart';
import 'package:todo/data/models/category_model.dart';
import 'package:todo/domain/entities/category.dart';
import 'package:todo/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource dataSource = CategoryDataSource();

  @override
  void addCategory(Category category) {
    dataSource.addCategory(CategoryModel.fromEntity(category));
  }

  @override
  void deleteCategory(String id) {
    dataSource.deleteCategory(id);
  }

  @override
  List<Category> getCategories() {
    return dataSource.getCategories().map((model) => model.toEntity()).toList();
  }
}
