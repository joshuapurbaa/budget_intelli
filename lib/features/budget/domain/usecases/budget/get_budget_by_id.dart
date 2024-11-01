import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetBudgetsById implements UseCase<Budget, String> {
  GetBudgetsById({required this.repository});

  final BudgetRepository repository;

  @override
  Future<Either<Failure, Budget>> call(String budgetId) async {
    return repository.getBudgetById(id: budgetId);
  }
}
