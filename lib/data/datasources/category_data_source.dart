import 'package:todo/data/models/category_model.dart';

class CategoryDataSource {
  final List<CategoryModel> categories = [];

  void addCategory(CategoryModel category) {
    categories.add(category);
  }

  void deleteCategory(String id) {
    categories.removeWhere((category) => category.id == id);
  }

  List<CategoryModel> getCategories() {
    return categories;
  }
}
