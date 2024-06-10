import 'package:todo/domain/repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  void call(String id) {
    repository.deleteCategory(id);
  }
}
