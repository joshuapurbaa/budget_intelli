import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetBudgetsFromFirestore implements UseCase<List<Budget>, NoParams> {
  GetBudgetsFromFirestore(this.repository);
  final BudgetFirestoreRepo repository;

  @override
  Future<Either<Failure, List<Budget>>> call(NoParams params) {
    return repository.getBudgetsFirestore();
  }
}
