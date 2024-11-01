import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertBudgetUsecase implements UseCase<Unit, Budget> {
  InsertBudgetUsecase({required this.repository});

  final BudgetRepository repository;

  @override
  Future<Either<Failure, Unit>> call(Budget budget) async {
    return repository.insertBudget(budget);
  }
}
