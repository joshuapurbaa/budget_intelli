import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class BudgetFirestoreRepoImpl implements BudgetFirestoreRepo {
  BudgetFirestoreRepoImpl({required this.budgetFirestoreApi});

  final BudgetFirestoreApi budgetFirestoreApi;
  @override
  Future<Either<Failure, List<Budget>>> getBudgetsFirestore() async {
    try {
      final budgetsFirestore = await budgetFirestoreApi.getBudgetsFirestore();
      final budgetFirestoreList = <Budget>[];

      for (final item in budgetsFirestore) {
        final budget = Budget(
          id: item.id,
          budgetName: item.budgetName,
          createdAt: item.createdAt,
          startDate: item.startDate,
          endDate: item.endDate,
          isActive: item.isActive,
          isMonthly: item.isMonthly,
          isWeekly: item.isWeekly,
          month: item.month,
          year: item.year,
          totalPlanIncome: item.totalPlanIncome,
          totalPlanExpense: item.totalPlanExpense,
          totalActualIncome: item.totalActualIncome,
          totalActualExpense: item.totalActualExpense,
        );
        budgetFirestoreList.add(budget);
      }

      return right(budgetFirestoreList);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Failed get budget list: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertBudgetFirestore(Budget budget) async {
    try {
      await budgetFirestoreApi.insertBudgetFirestore(budget);

      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Failed insert budget: ${e.message}'),
      );
    }
  }
}
