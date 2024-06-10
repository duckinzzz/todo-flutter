import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/entities/category.dart';
import 'package:todo/domain/usecases/add_category.dart';
import 'package:todo/domain/usecases/delete_category.dart';

class CategoryState {
  final List<Category> categories;

  CategoryState(this.categories);
}

class CategoryCubit extends Cubit<CategoryState> {
  final AddCategory addCategoryUseCase;
  final DeleteCategory deleteCategoryUseCase;

  CategoryCubit({required this.addCategoryUseCase, required this.deleteCategoryUseCase})
      : super(CategoryState([]));

  void addCategory(Category category) {
    addCategoryUseCase(category);
    emit(CategoryState([...state.categories, category]));
  }

  void deleteCategory(String id) {
    deleteCategoryUseCase(id);
    emit(CategoryState(
        state.categories.where((category) => category.id != id).toList()));
  }
}
