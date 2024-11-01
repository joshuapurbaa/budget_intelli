import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl({required this.localDataApi});

  final BudgetLocalApi localDataApi;

  @override
  Future<Either<Failure, Unit>> insertBudget(Budget budget) async {
    try {
      await localDataApi.insertBudget(budget);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Budget>> getBudgetById({
    required String id,
  }) async {
    try {
      final response = await localDataApi.getBudgetByIdApi(
        budgetId: id,
      );
      final budget = Budget(
        id: response.id,
        budgetName: response.budgetName,
        createdAt: response.createdAt,
        startDate: response.startDate,
        endDate: response.endDate,
        isActive: response.isActive,
        isMonthly: response.isMonthly,
        isWeekly: response.isWeekly,
        month: response.month,
        year: response.year,
        totalPlanIncome: response.totalPlanIncome,
        totalPlanExpense: response.totalPlanExpense,
        totalActualIncome: response.totalActualIncome,
        totalActualExpense: response.totalActualExpense,
        groupCategories: response.groupCategories != null
            ? response.groupCategories!.map((e) {
                return GroupCategoryHistory(
                  id: e.id,
                  groupName: e.groupName,
                  method: e.method,
                  type: e.type,
                  groupId: e.groupId,
                  budgetId: e.budgetId,
                  createdAt: e.createdAt,
                  updatedAt: e.updatedAt,
                  hexColor: e.hexColor,
                  itemCategoryHistories: e.itemCategoryHistories.map((e) {
                    return ItemCategoryHistory(
                      id: e.id,
                      name: e.name,
                      groupHistoryId: e.groupHistoryId,
                      itemId: e.itemId,
                      amount: e.amount,
                      type: e.type,
                      createdAt: e.createdAt,
                      isExpense: e.isExpense,
                      isFavorite: e.isFavorite,
                      carryOverAmount: e.carryOverAmount,
                      iconPath: e.iconPath,
                      hexColor: e.hexColor,
                      updatedAt: e.updatedAt,
                      startDate: e.startDate,
                      endDate: e.endDate,
                      budgetId: e.budgetId,
                      groupName: e.groupName,
                    );
                  }).toList(),
                );
              }).toList()
            : [],
      );

      return right(budget);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Budget>>> getAllBudgets() async {
    try {
      final budgets = await localDataApi.getAllBudgets();
      final budgetList = <Budget>[];

      for (final item in budgets) {
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
        budgetList.add(budget);
      }

      return right(budgetList);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateBudget(Budget budget) async {
    try {
      await localDataApi.updateBudget(budget);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBudget({required String id}) async {
    try {
      await localDataApi.deleteBudget(id: id);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }
}
