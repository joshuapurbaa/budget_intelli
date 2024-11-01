import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteGroupCategoryById implements UseCase<Unit, String> {
  DeleteGroupCategoryById(this.repository);

  final GroupCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteGroupCategoryHistoryById(id);
  }
}
