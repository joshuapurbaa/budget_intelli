import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateBudgetUsecase implements UseCase<Unit, Budget> {
  UpdateBudgetUsecase(this.budgetRepository);

  final BudgetRepository budgetRepository;

  @override
  Future<Either<Failure, Unit>> call(Budget budget) {
    return budgetRepository.updateBudget(budget);
  }
}
