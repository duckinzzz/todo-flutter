import 'package:todo/domain/entities/category.dart';

abstract class CategoryRepository {
  void addCategory(Category category);
  void deleteCategory(String id);
  List<Category> getCategories();
}
