import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetGroupCategoryHistoryByBudgetId
    implements UseCase<List<GroupCategoryHistory>, String> {
  GetGroupCategoryHistoryByBudgetId(this.repository);

  final GroupCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, List<GroupCategoryHistory>>> call(String budgetId) {
    return repository.getGroupCategoryHistoriesByBudgetId(budgetId);
  }
}
