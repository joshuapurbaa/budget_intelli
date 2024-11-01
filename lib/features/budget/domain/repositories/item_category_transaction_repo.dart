import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ItemCategoryTransactionRepository {
  Future<Either<Failure, List<ItemCategoryTransaction>>>
      getItemCategoryTransactionsByItemId({required String itemId});
  Future<Either<Failure, List<ItemCategoryTransaction>>>
      getItemCategoryTransactionsByBudgetId({required String budgetId});
  Future<Either<Failure, Unit>> insertItemCategoryTransaction(
    ItemCategoryTransaction itemCategoryTransaction,
  );
  Future<Either<Failure, Unit>> updateItemCategoryTransaction(
    ItemCategoryTransaction itemCategoryTransaction,
  );
  Future<Either<Failure, Unit>> deleteItemCategoryTransactionById(String id);
  Future<Either<Failure, Unit>> deleteItemCategoryTransactionByItemId(
    String itemId,
  );
  Future<Either<Failure, Unit>> deleteCategoryTransactionByGroupId(
    String groupId,
  );
  Future<Either<Failure, Unit>> deleteCategoryTransactionByBudgetId(
    String budgetId,
  );
  Future<Either<Failure, List<ItemCategoryTransaction>>>
      getAllItemCategoryTransactions();
}
