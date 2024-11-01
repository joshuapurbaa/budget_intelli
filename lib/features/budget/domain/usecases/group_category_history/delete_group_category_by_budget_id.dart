import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteGroupCategoryByBudgetId implements UseCase<Unit, String> {
  DeleteGroupCategoryByBudgetId(this.repository);

  final GroupCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteGroupCategoryHistoryByBudgetId(id);
  }
}
