import 'package:todo/domain/entities/category.dart';
import 'package:todo/domain/repositories/category_repository.dart';

class AddCategory {
  final CategoryRepository repository;

  AddCategory(this.repository);

  void call(Category category) {
    repository.addCategory(category);
  }
}
