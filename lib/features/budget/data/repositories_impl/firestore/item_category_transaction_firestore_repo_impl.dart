import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class ItemCategoryTransactionFirestoreRepoImpl implements ItemCategoryTransactionFirestoreRepo {
  ItemCategoryTransactionFirestoreRepoImpl({required this.budgetFirestoreApi});

  final BudgetFirestoreApi budgetFirestoreApi;

  @override
  Future<Either<Failure, List<ItemCategoryTransaction>>> getItemCategoryTransactionsFirestore() async {
    try {
      final itemCategoryTransactions = await budgetFirestoreApi.getItemCategoryTransactionsFirestore();
      final itemCategoryTransactionList = <ItemCategoryTransaction>[];

      for (final item in itemCategoryTransactions) {
        final itemCategoryTransaction = ItemCategoryTransaction(
          id: item.id,
          itemHistoId: item.itemHistoId,
          categoryName: item.categoryName,
          amount: item.amount,
          updatedAt: item.updatedAt,
          type: item.type,
          createdAt: item.createdAt,
          spendOn: item.spendOn,
          picture: item.picture,
          budgetId: item.budgetId,
          groupId: item.groupId,
          accountId: item.accountId,
        );
        itemCategoryTransactionList.add(itemCategoryTransaction);
      }

      return right(itemCategoryTransactionList);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure(
          'Failed get item category transaction list: ${e.message}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertItemCategoryTransactionFirestore(
    ItemCategoryTransaction itemCategoryTransaction,
  ) async {
    try {
      await budgetFirestoreApi.insertItemCategoryTransactionFirestore(
        itemCategoryTransaction,
      );
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure(
          'Failed insert item category transaction: ${e.message}',
        ),
      );
    }
  }
}
