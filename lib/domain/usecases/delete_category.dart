import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/domain/repositories/category_repository.dart';
import 'package:todo/domain/usecases/usecase.dart';

class DeleteCategory implements UseCase<void, String> {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    try {
      repository.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
