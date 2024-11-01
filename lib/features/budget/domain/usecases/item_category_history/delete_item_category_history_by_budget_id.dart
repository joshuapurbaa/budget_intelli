import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteItemCategoryHistoryByBudgetId implements UseCase<Unit, String> {
  DeleteItemCategoryHistoryByBudgetId(this.repository);

  final ItemCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteItemCategoryHistoryByBudgetId(budgetId: id);
  }
}
