import 'package:get_it/get_it.dart';
import 'package:todo/data/datasources/database.dart';
import 'package:todo/data/repositories/category_repository_impl.dart';
import 'package:todo/data/repositories/task_repository_impl.dart';
import 'package:todo/domain/repositories/category_repository.dart';
import 'package:todo/domain/repositories/task_repository.dart';
import 'package:todo/domain/usecases/add_category.dart';
import 'package:todo/domain/usecases/add_task.dart';
import 'package:todo/domain/usecases/delete_category.dart';
import 'package:todo/domain/usecases/delete_task.dart';
import 'package:todo/domain/usecases/update_task.dart';
import 'package:todo/presentation/blocs/category_bloc/category_bloc.dart';
import 'package:todo/presentation/blocs/task_bloc/task_bloc.dart';

final sl = GetIt.instance;

void setup() {
  final database = AppDatabase();

  // Database
  sl.registerLazySingleton(() => database);

  // Repositories
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(database));
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(database));

  // Use cases
  sl.registerLazySingleton(() => AddCategory(sl()));
  sl.registerLazySingleton(() => DeleteCategory(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));

  // Blocs
  sl.registerFactory(() => CategoryCubit(
    addCategoryUseCase: sl(),
    deleteCategoryUseCase: sl(),
  ));
  sl.registerFactory(() => TaskCubit(
    addTaskUseCase: sl(),
    deleteTaskUseCase: sl(),
    updateTaskUseCase: sl(),
  ));
}
