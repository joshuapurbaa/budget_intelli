import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetBudgetList implements UseCase<List<Budget>, NoParams> {
  GetBudgetList(this.repository);
  final BudgetRepository repository;

  @override
  Future<Either<Failure, List<Budget>>> call(NoParams params) {
    return repository.getAllBudgets();
  }
}
