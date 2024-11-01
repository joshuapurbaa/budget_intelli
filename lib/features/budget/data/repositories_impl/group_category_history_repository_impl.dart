import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GroupCategoryHistoryRepositoryImpl
    implements GroupCategoryHistoryRepository {
  GroupCategoryHistoryRepositoryImpl({required this.localDataApi});

  final BudgetLocalApi localDataApi;

  @override
  Future<Either<Failure, Unit>> insertGroupCategoryHistory(
    GroupCategoryHistory groupCategory,
  ) async {
    try {
      await localDataApi.insertGroupCategoryHistory(groupCategory);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<GroupCategoryHistory>>>
      getGroupCategoryHistories() async {
    try {
      final groupCategories = await localDataApi.getGroupCategoryHistories();
      final groupCategoryList = <GroupCategoryHistory>[];

      for (final group in groupCategories) {
        final itemCategories = GroupCategoryHistory(
          id: group.id,
          groupName: group.groupName,
          method: group.method,
          type: group.type,
          groupId: group.groupId,
          createdAt: group.createdAt,
          updatedAt: group.updatedAt,
          hexColor: group.hexColor,
          itemCategoryHistories: group.itemCategoryHistories.map((e) {
            return ItemCategoryHistory(
              id: e.id,
              name: e.name,
              groupHistoryId: e.groupHistoryId,
              itemId: e.itemId,
              amount: e.amount,
              type: e.type,
              createdAt: e.createdAt,
              isExpense: e.isExpense,
              budgetId: e.budgetId,
              groupName: group.groupName,
            );
          }).toList(),
        );
        groupCategoryList.add(itemCategories);
      }

      return right(groupCategoryList);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteGroupCategoryHistoryById(
    String id,
  ) async {
    try {
      await localDataApi.deleteGroupCategoryHistoryById(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  // @override
  // Future<Either<Failure, GroupCategoryHistory>> getGroupCategoryById(
  //   String id,
  // ) async {
  //   try {
  //     final groupCategory = await localDataApi.getGroupCategoryHistoryById(id);
  //     return right(
  //       GroupCategoryHistory(
  //         id: groupCategory.id,
  //         groupName: groupCategory.groupName,
  //         method: groupCategory.method,
  //         type: groupCategory.type,
  //         budgetId: groupCategory.budgetId,
  //         groupId: groupCategory.groupId,
  //         createdAt: groupCategory.createdAt,
  //         updatedAt: groupCategory.updatedAt,
  //         hexColor: groupCategory.hexColor,
  //         itemCategoryHistories: groupCategory.itemCategoryHistories.map((e) {
  //           return ItemCategoryHistory(
  //             id: e.id,
  //             name: e.name,
  //             groupHistoryId: e.groupHistoryId,
  //             itemId: e.itemId,
  //             amount: e.amount,
  //             type: e.type,
  //             createdAt: e.createdAt,
  //             isExpense: e.isExpense,
  //             isFavorite: e.isFavorite,
  //             carryOverAmount: e.carryOverAmount,
  //             iconPath: e.iconPath,
  //             hexColor: e.hexColor,
  //             updatedAt: e.updatedAt,
  //             startDate: e.startDate,
  //             endDate: e.endDate,
  //             remaining: e.remaining,
  //             budgetId: e.budgetId,
  //             groupName: e.groupName,
  //           );
  //         }).toList(),
  //       ),
  //     );
  //   } on CustomException catch (e) {
  //     return left(
  //       DatabaseFailure('Db failure: ${e.message}'),
  //     );
  //   }
  // }

  @override
  Future<Either<Failure, Unit>> updateGroupCategoryHistory(
    GroupCategoryHistory groupCategory,
  ) async {
    try {
      final model = GroupCategoryHistory(
        id: groupCategory.id,
        groupName: groupCategory.groupName,
        method: groupCategory.method,
        type: groupCategory.type,
        budgetId: groupCategory.budgetId,
        groupId: groupCategory.groupId,
        createdAt: groupCategory.createdAt,
        updatedAt: groupCategory.updatedAt,
        hexColor: groupCategory.hexColor,
        itemCategoryHistories: groupCategory.itemCategoryHistories.map((e) {
          assert(e.budgetId != null, 'Budget id is required');
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
            remaining: e.remaining,
            budgetId: e.budgetId,
            groupName: e.groupName,
          );
        }).toList(),
      );
      await localDataApi.updateGroupCategoryHistory(model);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteGroupCategoryHistoryByBudgetId(
    String budgetId,
  ) async {
    try {
      await localDataApi.deleteGroupCategoryHistoryByBudgetId(budgetId);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, GroupCategoryHistory>> getGroupCategoryHistoryById(
    String id,
  ) async {
    try {
      final groupCategory =
          await localDataApi.getSingleGroupCategoryHistoryById(id);
      return right(
        GroupCategoryHistory(
          id: groupCategory.id,
          groupName: groupCategory.groupName,
          method: groupCategory.method,
          type: groupCategory.type,
          budgetId: groupCategory.budgetId,
          groupId: groupCategory.groupId,
          itemCategoryHistories: [],
          createdAt: groupCategory.createdAt,
          updatedAt: groupCategory.updatedAt,
          hexColor: groupCategory.hexColor,
        ),
      );
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<GroupCategoryHistory>>>
      getGroupCategoryHistoriesByBudgetId(String budgetId) async {
    try {
      final groupCategories =
          await localDataApi.getGroupCategoryHistoriesByBudgetId(budgetId);
      final groupCategoryList = <GroupCategoryHistory>[];

      for (final group in groupCategories) {
        final itemCategories = GroupCategoryHistory(
          id: group.id,
          groupName: group.groupName,
          method: group.method,
          type: group.type,
          groupId: group.groupId,
          itemCategoryHistories: [],
          createdAt: group.createdAt,
          updatedAt: group.updatedAt,
          hexColor: group.hexColor,
        );
        groupCategoryList.add(itemCategories);
      }

      return right(groupCategoryList);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateGroupCategoryHistoryNoItemCategory(
    GroupCategoryHistory groupCategoryHistory,
  ) async {
    try {
      final model = GroupCategoryHistory(
        id: groupCategoryHistory.id,
        groupName: groupCategoryHistory.groupName,
        method: groupCategoryHistory.method,
        type: groupCategoryHistory.type,
        budgetId: groupCategoryHistory.budgetId,
        groupId: groupCategoryHistory.groupId,
        createdAt: groupCategoryHistory.createdAt,
        updatedAt: groupCategoryHistory.updatedAt,
        hexColor: groupCategoryHistory.hexColor,
      );
      await localDataApi.updateGroupCategoryHistoryNoItemCategory(model);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }
}
