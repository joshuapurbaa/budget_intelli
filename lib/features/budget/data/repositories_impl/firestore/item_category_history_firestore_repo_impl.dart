import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class ItemCategoryHistoryFirestoreRepoImpl implements ItemCategoryHistoryFirestoreRepo {
  ItemCategoryHistoryFirestoreRepoImpl({
    required this.budgetFirestoreApi,
  });

  final BudgetFirestoreApi budgetFirestoreApi;

  @override
  Future<Either<Failure, List<ItemCategoryHistory>>> getItemCategoryHistoriesFirestore() async {
    try {
      final itemCategories = await budgetFirestoreApi.getItemCategoryHistoriesFirestore();
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
        DatabaseFailure('Failed get item category history list: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertItemCategoryHistoryFirestore(
    ItemCategoryHistory itemCategoryHistory,
  ) async {
    try {
      await budgetFirestoreApi.insertItemCategoryHistoryFirestore(
        itemCategoryHistory,
      );
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Failed insert item category history: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItemCategoryHistoryFirestore(String id) async {
    try {
      await budgetFirestoreApi.deleteItemCategoryHistoryFirestore(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Failed delete item category history: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItemCategoryHistoryFirestore(ItemCategoryHistory itemCategoryHistory) async {
    try {
      await budgetFirestoreApi.updateItemCategoryHistoryFirestore(itemCategoryHistory);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Failed update item category history: ${e.message}'),
      );
    }
  }
}
