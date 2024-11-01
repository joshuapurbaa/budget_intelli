import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetItemCategoryTransactionsByBudgetId
    implements UseCase<List<ItemCategoryTransaction>, String> {
  GetItemCategoryTransactionsByBudgetId(this.repository);

  final ItemCategoryTransactionRepository repository;

  @override
  Future<Either<Failure, List<ItemCategoryTransaction>>> call(String budgetId) {
    return repository.getItemCategoryTransactionsByBudgetId(budgetId: budgetId);
  }
}
