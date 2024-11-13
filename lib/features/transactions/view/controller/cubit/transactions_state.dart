part of 'transactions_cubit.dart';

@immutable
sealed class TransactionsState {}

final class TransactionsInitial extends TransactionsState {}

final class TransactionsLoading extends TransactionsState {}

final class AddExpenseTransactionSuccess extends TransactionsState {
  AddExpenseTransactionSuccess({
    required this.itemCategoryTransaction,
    required this.selectedAccount,
    required this.amount,
    required this.budgetId,
  });

  final ItemCategoryTransaction itemCategoryTransaction;
  final Account selectedAccount;
  final double amount;
  final String budgetId;
}

final class AddExpenseTransactionFailed extends TransactionsState {
  AddExpenseTransactionFailed({required this.message});

  final String message;
}

final class UpdateBudgetSuccess extends TransactionsState {}

final class UpdateBudgetFailed extends TransactionsState {
  UpdateBudgetFailed({required this.message});

  final String message;
}

final class UpdateItemCategoryTransactionSuccess extends TransactionsState {}

final class UpdateItemCategoryTransactionFailed extends TransactionsState {
  UpdateItemCategoryTransactionFailed({required this.message});

  final String message;
}

final class GetItemCategoryTransactionsByBudgetIdSuccess
    extends TransactionsState {
  GetItemCategoryTransactionsByBudgetIdSuccess({required this.transactions});

  final List<ItemCategoryTransaction> transactions;
}

final class GetItemCategoryTransactionsByBudgetIdFailed
    extends TransactionsState {
  GetItemCategoryTransactionsByBudgetIdFailed({required this.message});

  final String message;
}
