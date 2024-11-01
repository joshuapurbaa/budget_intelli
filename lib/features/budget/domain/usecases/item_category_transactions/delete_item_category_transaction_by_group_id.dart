import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteCategoryTransactionByGroupId implements UseCase<Unit, String> {
  DeleteCategoryTransactionByGroupId(this.repository);

  final ItemCategoryTransactionRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String groupId) {
    return repository.deleteCategoryTransactionByGroupId(groupId);
  }
}
