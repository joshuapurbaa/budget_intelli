import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

class ItemCategoryTransactionRepositoryImpl implements ItemCategoryTransactionRepository {
  ItemCategoryTransactionRepositoryImpl({
    required this.localDataApi,
  });

  final BudgetLocalApi localDataApi;

  @override
  Future<Either<Failure, List<ItemCategoryTransaction>>> getItemCategoryTransactionsByItemId({
    required String itemId,
  }) async {
    try {
      final itemCategoryTransactions = await localDataApi.getItemCategoryTransactionsByItemId(itemId);
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
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertItemCategoryTransaction(
    ItemCategoryTransaction transaction,
  ) async {
    try {
      final model = ItemCategoryTransaction(
        id: transaction.id,
        itemHistoId: transaction.itemHistoId,
        categoryName: transaction.categoryName,
        amount: transaction.amount,
        updatedAt: transaction.updatedAt,
        type: transaction.type,
        createdAt: transaction.createdAt,
        spendOn: transaction.spendOn,
        picture: transaction.picture,
        budgetId: transaction.budgetId,
        groupId: transaction.groupId,
        accountId: transaction.accountId,
      );
      await localDataApi.insertItemCategoryTransaction(model);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItemCategoryTransactionById(
    String id,
  ) async {
    try {
      await localDataApi.deleteItemCategoryTransactionById(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateItemCategoryTransaction(
    ItemCategoryTransaction itemCategoryTransaction,
  ) async {
    try {
      await localDataApi.updateItemCategoryTransaction(itemCategoryTransaction);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ItemCategoryTransaction>>> getItemCategoryTransactionsByBudgetId({
    required String budgetId,
  }) async {
    try {
      final itemCategoryTransactions = await localDataApi.getItemCategoryTransactionsByBudgetId(budgetId);
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
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItemCategoryTransactionByItemId(
    String itemId,
  ) async {
    try {
      await localDataApi.deleteItemCategoryTransactionByItemId(itemId);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategoryTransactionByGroupId(
    String groupId,
  ) async {
    try {
      await localDataApi.deleteCategoryTransactionByGroupId(groupId);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ItemCategoryTransaction>>> getAllItemCategoryTransactions() async {
    try {
      final itemCategoryTransactions = await localDataApi.getAllItemCategoryTransactions();
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
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategoryTransactionByBudgetId(
    String budgetId,
  ) async {
    try {
      await localDataApi.deleteCategoryTransactionByBudgetId(budgetId);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }
}
