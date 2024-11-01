import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteItemCategoryTransactionByBudgetId implements UseCase<Unit, String> {
  DeleteItemCategoryTransactionByBudgetId(this.repository);

  final ItemCategoryTransactionRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteCategoryTransactionByBudgetId(id);
  }
}
