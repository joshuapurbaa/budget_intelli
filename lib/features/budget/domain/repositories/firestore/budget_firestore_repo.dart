import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BudgetFirestoreRepo {
  Future<Either<Failure, Unit>> insertBudgetFirestore(Budget budget);
  Future<Either<Failure, List<Budget>>> getBudgetsFirestore();
}
