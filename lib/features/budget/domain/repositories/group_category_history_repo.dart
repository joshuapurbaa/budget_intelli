import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GroupCategoryHistoryRepository {
  Future<Either<Failure, Unit>> insertGroupCategoryHistory(
    GroupCategoryHistory groupCategoryHistory,
  );

  Future<Either<Failure, List<GroupCategoryHistory>>> getGroupCategoryHistories();

  Future<Either<Failure, List<GroupCategoryHistory>>> getGroupCategoryHistoriesByBudgetId(String budgetId);

  Future<Either<Failure, Unit>> updateGroupCategoryHistory(
    GroupCategoryHistory groupCategoryHistory,
  );

  Future<Either<Failure, Unit>> updateGroupCategoryHistoryNoItemCategory(
    GroupCategoryHistory groupCategoryHistory,
  );

  Future<Either<Failure, GroupCategoryHistory>> getGroupCategoryHistoryById(
    String id,
  );

  Future<Either<Failure, Unit>> deleteGroupCategoryHistoryById(String id);

  Future<Either<Failure, Unit>> deleteGroupCategoryHistoryByBudgetId(
    String budgetId,
  );
}
