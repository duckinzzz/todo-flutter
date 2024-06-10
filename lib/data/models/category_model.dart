import 'package:todo/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required String id,
    required String name,
    required DateTime createdAt,
  }) : super(id: id, name: name, createdAt: createdAt);

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      createdAt: category.createdAt,
    );
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      createdAt: createdAt,
    );
  }
}
