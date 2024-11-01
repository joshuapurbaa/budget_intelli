import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetItemCategoryHistoriesByBudgetId
    implements UseCase<List<ItemCategoryHistory>, String> {
  GetItemCategoryHistoriesByBudgetId(this.repository);
  final ItemCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, List<ItemCategoryHistory>>> call(
    String budgetId,
  ) async {
    return repository.getItemCategoryHistoriesByBudgetId(budgetId: budgetId);
  }
}
