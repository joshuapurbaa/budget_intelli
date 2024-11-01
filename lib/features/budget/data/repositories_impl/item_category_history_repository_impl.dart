import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class ItemCategoryHistoryRepositoryImpl
    implements ItemCategoryHistoryRepository {
  ItemCategoryHistoryRepositoryImpl({
    required this.localDataApi,
  });

  final BudgetLocalApi localDataApi;

  @override
  Future<Either<Failure, List<ItemCategoryHistory>>>
      getItemCategoryHistoriesByBudgetId({
    required String budgetId,
  }) async {
    try {
      final itemCategories = await localDataApi
          .getItemCategoryHistoryByBudgetId(budgetId: budgetId);
      final itemCategoryList = <ItemCategoryHistory>[];

      for (final item in itemCategories) {
        final itemCategory = ItemCategoryHistory(
          id: item.id,
          name: item.name,
          groupHistoryId: item.groupHistoryId,
          itemId: item.itemId,
          amount: item.amount,
          type: item.type,
          createdAt: item.createdAt,
          isExpense: item.isExpense,
          isFavorite: item.isFavorite,
          carryOverAmount: item.carryOverAmount,
          iconPath: item.iconPath,
          hexColor: item.hexColor,
          updatedAt: item.updatedAt,
          startDate: item.startDate,
          endDate: item.endDate,
          remaining: item.remaining,
          budgetId: item.budgetId,
          groupName: item.groupName,
        );

        itemCategoryList.add(itemCategory);
      }

      return right(itemCategoryList);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ItemCategoryHistory>>>
      getItemCategoryHistories() async {
    try {
      final itemCategories = await localDataApi.getItemCategoryHistories();
      final itemCategoryList = <ItemCategoryHistory>[];

      for (final item in itemCategories) {
        final itemCategory = ItemCategoryHistory(
          id: item.id,
          name: item.name,
          groupHistoryId: item.groupHistoryId,
          itemId: item.itemId,
          amount: item.amount,
          type: item.type,
          createdAt: item.createdAt,
          isExpense: item.isExpense,
          isFavorite: item.isFavorite,
          carryOverAmount: item.carryOverAmount,
          iconPath: item.iconPath,
          hexColor: item.hexColor,
          updatedAt: item.updatedAt,
          startDate: item.startDate,
          endDate: item.endDate,
          remaining: item.remaining,
          budgetId: item.budgetId,
          groupName: item.groupName,
        );

        itemCategoryList.add(itemCategory);
      }

      return right(itemCategoryList);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ItemCategoryHistory>>>
      getItemCategoryHistoriesByGroupId({
    required String groupId,
  }) async {
    try {
      final itemCategories = await localDataApi.getItemCategoryHistoryByGroupId(
        groupId: groupId,
      );
      final itemCategoryList = <ItemCategoryHistory>[];

      for (final item in itemCategories) {
        final itemCategory = ItemCategoryHistory(
          id: item.id,
          name: item.name,
          groupHistoryId: item.groupHistoryId,
          itemId: item.itemId,
          amount: item.amount,
          type: item.type,
          createdAt: item.createdAt,
          isExpense: item.isExpense,
          isFavorite: item.isFavorite,
          carryOverAmount: item.carryOverAmount,
          iconPath: item.iconPath,
          hexColor: item.hexColor,
          updatedAt: item.updatedAt,
          startDate: item.startDate,
          endDate: item.endDate,
          remaining: item.remaining,
          budgetId: item.budgetId,
          groupName: item.groupName,
        );
        itemCategoryList.add(itemCategory);
      }

      return right(itemCategoryList);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItemCategoryHistoryById({
    required String id,
  }) async {
    try {
      await localDataApi.deleteItemCategoryHistoryById(id: id);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItemCategoryHistory(
    ItemCategoryHistory itemCategory,
  ) async {
    try {
      await localDataApi.updateItemCategoryHistory(itemCategory);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, ItemCategoryHistory>> getItemCategoryHistoryById(
    String id,
  ) async {
    try {
      final itemCategory = await localDataApi.getItemCategoryHistoryById(id);

      return right(
        ItemCategoryHistory(
          id: itemCategory.id,
          name: itemCategory.name,
          amount: itemCategory.amount,
          groupHistoryId: itemCategory.groupHistoryId,
          itemId: itemCategory.itemId,
          type: itemCategory.type,
          createdAt: itemCategory.createdAt,
          isExpense: itemCategory.isExpense,
          hexColor: itemCategory.hexColor,
          updatedAt: itemCategory.updatedAt,
          startDate: itemCategory.startDate,
          endDate: itemCategory.endDate,
          isFavorite: itemCategory.isFavorite,
          carryOverAmount: itemCategory.carryOverAmount,
          iconPath: itemCategory.iconPath,
          budgetId: itemCategory.budgetId,
          groupName: itemCategory.groupName,
        ),
      );
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertItemCategoryHistories(
    ItemCategoryHistory itemCategory,
  ) async {
    try {
      await localDataApi.insertItemCategoryHistory(itemCategory);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItemCategoryHistoryByGroupId({
    required String groupId,
  }) async {
    try {
      await localDataApi.deleteItemCategoryHistoryByGroupId(
        groupId: groupId,
      );
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItemCategoryHistoryByBudgetId({
    required String budgetId,
  }) async {
    try {
      await localDataApi.deleteItemCategoryHistoryByBudgetId(
        budgetId: budgetId,
      );
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }
}
