import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit({
    required InsertItemCategoryTransaction insertItemCategoryTransaction,
    required UpdateBudgetUsecase updateBudgetDB,
    required UpdateItemCategoryTransaction updateItemCategoryTransaction,
    required GetItemCategoryTransactionsByBudgetId
        getItemCategoryTransactionsByBudgetId,
    required InsertAccountHistoryUsecase insertAccountHistoryUsecase,
    required UpdateAccountUsecase updateAccountUsecase,
  })  : _insertItemCategoryTransaction = insertItemCategoryTransaction,
        _updateBudgetDB = updateBudgetDB,
        _updateItemCategoryTransaction = updateItemCategoryTransaction,
        _getItemCategoryTransactionsByBudgetId =
            getItemCategoryTransactionsByBudgetId,
        _insertAccountHistoryUsecase = insertAccountHistoryUsecase,
        _updateAccountUsecase = updateAccountUsecase,
        super(TransactionsInitial());

  final InsertItemCategoryTransaction _insertItemCategoryTransaction;
  final UpdateBudgetUsecase _updateBudgetDB;
  final UpdateItemCategoryTransaction _updateItemCategoryTransaction;
  final GetItemCategoryTransactionsByBudgetId
      _getItemCategoryTransactionsByBudgetId;
  final InsertAccountHistoryUsecase _insertAccountHistoryUsecase;
  final UpdateAccountUsecase _updateAccountUsecase;

  void setToInitial() {
    emit(TransactionsInitial());
  }

  Future<void> insertItemCategoryTransaction({
    required ItemCategoryTransaction itemCategoryTransaction,
    required Account selectedAccount,
    required double amount,
    required String budgetId,
  }) async {
    emit(TransactionsLoading());
    final isExpense = itemCategoryTransaction.type == AppStrings.expenseType;

    final accountHistory = AccountHistory(
      id: const Uuid().v1(),
      accountId: selectedAccount.id,
      name: selectedAccount.name,
      amount: amount,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      iconPath: null,
      hexColor: null,
    );

    final resultAddAccountHisto = await _insertAccountHistory(accountHistory);

    if (resultAddAccountHisto) {
      await _updateAccount(
        selectedAccount,
        isExpense: isExpense,
        amount: amount,
      );

      final result =
          await _insertItemCategoryTransaction(itemCategoryTransaction);

      result.fold(
        (failure) {
          emit(
            AddExpenseTransactionFailed(
              message: failure.message,
            ),
          );
        },
        (_) => emit(
          AddExpenseTransactionSuccess(
            itemCategoryTransaction: itemCategoryTransaction,
            selectedAccount: selectedAccount,
            amount: amount,
            budgetId: budgetId,
          ),
        ),
      );
    }
  }

  Future<bool> _insertAccountHistory(AccountHistory accountHistory) async {
    final result = await _insertAccountHistoryUsecase(
      accountHistory,
    );

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  Future<bool> _updateAccount(
    Account account, {
    required bool isExpense,
    required double amount,
  }) async {
    Account? updatedAccount;

    if (isExpense) {
      updatedAccount = account.copyWith(
        amount: account.amount - amount,
      );
    } else {
      updatedAccount = account.copyWith(
        amount: account.amount + amount,
      );
    }

    final result = await _updateAccountUsecase(updatedAccount);

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  Future<void> updateBudget({
    required Budget budget,
  }) async {
    emit(TransactionsLoading());
    final result = await _updateBudgetDB(budget);

    result.fold(
      (failure) => emit(
        UpdateBudgetFailed(message: failure.message),
      ),
      (_) => emit(
        UpdateBudgetSuccess(),
      ),
    );
  }

  Future<void> updateItemCategoryTransaction(
    ItemCategoryTransaction transaction, {
    Account? selectedAccount,
    double? amount,
  }) async {
    emit(TransactionsLoading());

    if (selectedAccount != null && amount != null) {
      final isExpense = transaction.type == AppStrings.expenseType;

      final accountHistory = AccountHistory(
        id: const Uuid().v1(),
        accountId: selectedAccount.id,
        name: selectedAccount.name,
        amount: amount,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        iconPath: null,
        hexColor: null,
      );

      final resultAddAccountHisto = await _insertAccountHistory(accountHistory);

      if (resultAddAccountHisto) {
        await _updateAccount(
          selectedAccount,
          isExpense: isExpense,
          amount: amount,
        );
      }

      final result = await _updateItemCategoryTransaction(
        transaction,
      );

      result.fold(
        (failure) {
          emit(
            UpdateItemCategoryTransactionFailed(
              message: failure.message,
            ),
          );
        },
        (_) => emit(
          UpdateItemCategoryTransactionSuccess(),
        ),
      );
    } else {
      final result = await _updateItemCategoryTransaction(
        transaction,
      );

      result.fold(
        (failure) {
          emit(
            UpdateItemCategoryTransactionFailed(
              message: failure.message,
            ),
          );
        },
        (_) => emit(
          UpdateItemCategoryTransactionSuccess(),
        ),
      );
    }
  }

  Future<void> getItemCategoryTransactionsByBudgetId({
    required String budgetId,
  }) async {
    final result = await _getItemCategoryTransactionsByBudgetId(budgetId);

    result.fold(
      (failure) => emit(
        GetItemCategoryTransactionsByBudgetIdFailed(
          message: failure.message,
        ),
      ),
      (transactions) => emit(
        GetItemCategoryTransactionsByBudgetIdSuccess(
          transactions: transactions,
        ),
      ),
    );
  }
}
