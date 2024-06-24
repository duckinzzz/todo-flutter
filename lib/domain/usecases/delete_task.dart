import 'package:dartz/dartz.dart';
import 'package:todo/core/error/failures.dart';
import 'package:todo/domain/repositories/task_repository.dart';
import 'package:todo/domain/usecases/usecase.dart';

class DeleteTask implements UseCase<void, String> {
  final TaskRepository repository;

  DeleteTask(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    try {
      repository.deleteTask(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
