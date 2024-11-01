import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BudgetRepository {
  Future<Either<Failure, Unit>> insertBudget(Budget budget);
  Future<Either<Failure, List<Budget>>> getAllBudgets();
  Future<Either<Failure, Unit>> updateBudget(Budget budget);
  Future<Either<Failure, Budget>> getBudgetById({required String id});
  Future<Either<Failure, Unit>> deleteBudget({required String id});
}
