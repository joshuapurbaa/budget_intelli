import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertBudgetToFirestore implements UseCase<Unit, Budget> {
  InsertBudgetToFirestore(this.repository);

  final BudgetFirestoreRepo repository;

  @override
  Future<Either<Failure, Unit>> call(Budget budget) async {
    return repository.insertBudgetFirestore(budget);
  }
}
