import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class ItemCategoryFirestoreRepoImpl implements ItemCategoryFirestoreRepo {
  ItemCategoryFirestoreRepoImpl({
    required this.budgetFirestoreApi,
  });

  final BudgetFirestoreApi budgetFirestoreApi;

  @override
  Future<Either<Failure, List<ItemCategory>>>
      getItemCategoriesFirestore() async {
    try {
      final itemCategories = <ItemCategory>[];
      final list = await budgetFirestoreApi.getItemCategoriesFirestore();

      for (final item in list) {
        itemCategories.add(
          ItemCategory(
            id: item.id,
            categoryName: item.categoryName,
            createdAt: item.createdAt,
            updatedAt: item.updatedAt,
            type: item.type,
            iconPath: item.iconPath,
            hexColor: item.hexColor,
          ),
        );
      }

      return right(itemCategories);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Failed get item category list: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertItemCategoryFirestore(
    ItemCategory itemCategory,
  ) async {
    try {
      await budgetFirestoreApi.insertItemCategoryFirestore(itemCategory);

      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Failed insert item category: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItemCategoryFirestore(
    ItemCategory itemCategory,
  ) async {
    try {
      await budgetFirestoreApi.updateItemCategoryFirestore(itemCategory);

      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Failed update item category: ${e.message}'),
      );
    }
  }
}
