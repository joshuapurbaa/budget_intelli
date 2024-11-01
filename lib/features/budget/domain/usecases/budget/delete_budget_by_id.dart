import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBudgetById implements UseCase<Unit, String> {
  DeleteBudgetById(this.repository);

  final BudgetRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteBudget(id: id);
  }
}
