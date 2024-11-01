import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GroupCategoryHistoryFirestoreRepoImpl implements GroupCategoryHistoryFirestoreRepo {
  GroupCategoryHistoryFirestoreRepoImpl({
    required this.budgetFirestoreApi,
  });

  final BudgetFirestoreApi budgetFirestoreApi;

  @override
  Future<Either<Failure, List<GroupCategoryHistory>>> getGroupCategoryHistoriesFirestore() async {
    try {
      final groupCategories = await budgetFirestoreApi.getGroupCategoryHistoriesFirestore();
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
        DatabaseFailure('Failed get group category list: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertGroupCategoryHistoryFirestore(
    GroupCategoryHistory groupCategoryHistory,
  ) async {
    try {
      await budgetFirestoreApi.insertGroupCategoryHistoryFirestore(
        groupCategoryHistory,
      );
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Failed insert group category: ${e.message}'),
      );
    }
  }
}
