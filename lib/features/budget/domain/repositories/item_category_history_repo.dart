import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ItemCategoryHistoryRepository {
  Future<Either<Failure, Unit>> insertItemCategoryHistories(
    ItemCategoryHistory itemCategory,
  );
  Future<Either<Failure, ItemCategoryHistory>> getItemCategoryHistoryById(
      String id,);
  Future<Either<Failure, Unit>> updateItemCategoryHistory(
    ItemCategoryHistory itemCategory,
  );
  Future<Either<Failure, List<ItemCategoryHistory>>>
      getItemCategoryHistoriesByGroupId({
    required String groupId,
  });
  Future<Either<Failure, List<ItemCategoryHistory>>>
      getItemCategoryHistoriesByBudgetId({
    required String budgetId,
  });
  Future<Either<Failure, Unit>> deleteItemCategoryHistoryById(
      {required String id,});
  Future<Either<Failure, Unit>> deleteItemCategoryHistoryByGroupId({
    required String groupId,
  });
  Future<Either<Failure, Unit>> deleteItemCategoryHistoryByBudgetId({
    required String budgetId,
  });
  Future<Either<Failure, List<ItemCategoryHistory>>> getItemCategoryHistories();
}
