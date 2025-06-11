import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'budget_firestore_state.dart';

class BudgetFirestoreCubit extends Cubit<BudgetFirestoreState> {
  BudgetFirestoreCubit({
    required InsertItemCategoryToFirestore insertItemCategoryToFirestore,
    required InsertItemCategoryHistoryToFirestore
        insertItemCategoryHistoryToFirestore,
    required InsertGroupCategoryToFirestore insertGroupCategoryToFirestore,
    required InsertGroupCategoryHistoryToFirestore
        insertGroupCategoryHistoryToFirestore,
    required InsertBudgetToFirestore insertBudgetToFirestore,
    required UpdateUserFirestoreUsecases updateUserFire,
    required UpdateItemCategoryHistoryFirestore
        updateItemCategoryHistoryFirestore,
    required UpdateItemCategoryFirestore updateItemCategoryFirestore,
    // required DeleteItemCategoryHistoryFirestore deleteItemCategoryHistoryFirestore,
    required InsertAccountHistoryFire insertAccountHistoryFirestore,
    required UpdateAccountFirestore updateAccountFirestore,
    required InsertItemCategoryTransactionToFirestore
        insertItemCategoryTransactionFirestore,
    required InsertAccountFirestore insertAccountFirestore,
  })  : _insertItemCategoryToFirestore = insertItemCategoryToFirestore,
        _insertItemCategoryHistoryToFirestore =
            insertItemCategoryHistoryToFirestore,
        _insertGroupCategoryToFirestore = insertGroupCategoryToFirestore,
        _insertGroupCategoryHistoryToFirestore =
            insertGroupCategoryHistoryToFirestore,
        _insertBudgetToFirestore = insertBudgetToFirestore,
        _updateUserFire = updateUserFire,
        _updateItemCategoryHistoryFirestore =
            updateItemCategoryHistoryFirestore,
        _updateItemCategoryFirestore = updateItemCategoryFirestore,
        // _deleteItemCategoryHistoryFirestore = deleteItemCategoryHistoryFirestore,
        _insertAccountHistoryFirestore = insertAccountHistoryFirestore,
        _updateAccountFirestore = updateAccountFirestore,
        _insertItemCategoryTransaction = insertItemCategoryTransactionFirestore,
        _insertAccountFirestore = insertAccountFirestore,
        super(
          const BudgetFirestoreState(),
        );

  final InsertItemCategoryToFirestore _insertItemCategoryToFirestore;
  final InsertItemCategoryHistoryToFirestore
      _insertItemCategoryHistoryToFirestore;
  final InsertGroupCategoryToFirestore _insertGroupCategoryToFirestore;
  final InsertGroupCategoryHistoryToFirestore
      _insertGroupCategoryHistoryToFirestore;
  final InsertBudgetToFirestore _insertBudgetToFirestore;
  final UpdateUserFirestoreUsecases _updateUserFire;
  final UpdateItemCategoryHistoryFirestore _updateItemCategoryHistoryFirestore;
  final UpdateItemCategoryFirestore _updateItemCategoryFirestore;
  // final DeleteItemCategoryHistoryFirestore _deleteItemCategoryHistoryFirestore;
  final InsertAccountHistoryFire _insertAccountHistoryFirestore;
  final UpdateAccountFirestore _updateAccountFirestore;
  final InsertItemCategoryTransactionToFirestore _insertItemCategoryTransaction;
  final InsertAccountFirestore _insertAccountFirestore;

  void resetState() {
    emit(
      state.copyWith(
        loadingFirestore: false,
        insertItemHistoryFireSuccess: false,
        initial: false,
        insertGroupCategoryHistorySuccess: false,
        insertBudgetToFirestoreSuccess: false,
        updateItemHistoryFireSuccess: false,
        deleteItemHistoryFireSuccess: false,
        insertItemCategoryTransactionSuccess: false,
        updateAccountSuccess: false,
        insertAccountSuccess: false,
      ),
    );
  }

  Future<void> insertBudgetToFirestore({
    required List<GroupCategoryHistory> groupCategoryHistoriesParams,
    required List<ItemCategoryHistory> itemCategoryHistoriesParams,
    required Budget budgetParams,
    required bool fromInitial,
    required UserIntelli? user,
    required bool fromSync,
    List<GroupCategory>? groupCategoriesParams,
    List<ItemCategory>? itemCategories,
  }) async {
    try {
      emit(
        state.copyWith(
          loadingFirestore: true,
        ),
      );

      for (final itemCategory in itemCategoryHistoriesParams) {
        final item = ItemCategory(
          id: itemCategory.itemId,
          categoryName: itemCategory.name,
          type: itemCategory.type,
          createdAt: itemCategory.createdAt,
          updatedAt: itemCategory.updatedAt,
          iconPath: itemCategory.iconPath,
          hexColor: itemCategory.hexColor,
        );

        final insertItemResult = await _insertItemCategoryFire(
          itemCategory: item,
          itemCategories: itemCategories,
          fromInitial: fromInitial,
          fromSync: fromSync,
        );

        if (insertItemResult) {
          final result =
              await _insertItemCategoryHistoryToFirestore.call(itemCategory);

          result.fold(
            (l) => emit(
              state.copyWith(
                insertItemHistoryFireSuccess: false,
                errorMessage: l.message,
                initial: false,
                loadingFirestore: false,
              ),
            ),
            (r) {
              emit(
                state.copyWith(
                  insertItemHistoryFireSuccess: true,
                  initial: false,
                ),
              );
            },
          );
        } else {
          emit(
            state.copyWith(
              insertItemHistoryFireSuccess: false,
              errorMessage: 'Failed to insert item category',
              initial: false,
              loadingFirestore: false,
            ),
          );
        }
      }

      if (state.insertItemHistoryFireSuccess == true) {
        for (final groupCategory in groupCategoryHistoriesParams) {
          final insertGroupResult = await _insertGroupCategory(
            groupCategory: GroupCategory(
              id: groupCategory.groupId,
              groupName: groupCategory.groupName,
              type: groupCategory.type,
              createdAt: DateTime.now().toString(),
              updatedAt: DateTime.now().toString(),
              iconPath: null,
              hexColor: groupCategory.hexColor,
            ),
            groupCategories: groupCategoriesParams,
            fromInitial: fromInitial,
            fromSync: fromSync,
          );

          if (insertGroupResult) {
            final result = await _insertGroupCategoryHistoryToFirestore.call(
              groupCategory,
            );
            result.fold(
              (l) => emit(
                state.copyWith(
                  insertGroupCategoryHistorySuccess: false,
                  errorMessage: l.message,
                  initial: false,
                  loadingFirestore: false,
                ),
              ),
              (r) => emit(
                state.copyWith(
                  insertGroupCategoryHistorySuccess: true,
                  initial: false,
                ),
              ),
            );
          } else {
            emit(
              state.copyWith(
                insertGroupCategoryHistorySuccess: false,
                errorMessage: 'Failed to insert group category history',
                initial: false,
                loadingFirestore: false,
              ),
            );
          }
        }
      }

      if (state.insertGroupCategoryHistorySuccess == true) {
        if (user != null) {
          final userResult = await _updateUserFirestore(
            user.copyWith(
              budgetIds: [...user.budgetIds, budgetParams.id],
            ),
          );

          if (userResult) {
            final result = await _insertBudgetToFirestore.call(budgetParams);

            result.fold(
              (l) => emit(
                state.copyWith(
                  insertBudgetToFirestoreSuccess: false,
                  errorMessage: l.message,
                  initial: false,
                  loadingFirestore: false,
                ),
              ),
              (r) => emit(
                state.copyWith(
                  insertBudgetToFirestoreSuccess: true,
                  initial: false,
                  loadingFirestore: false,
                ),
              ),
            );
          }
        }
      }
    } on Exception {
      emit(
        state.copyWith(
          insertBudgetToFirestoreSuccess: false,
          errorMessage: 'Failed to insert budget',
          initial: false,
          loadingFirestore: false,
        ),
      );
    }
  }

  Future<void> insertNewGroupCategoryFirestore({
    required List<GroupCategoryHistory> groupCategoryHistory,
    required List<ItemCategoryHistory> itemCategoriesParams,
    List<GroupCategory>? groupCategories,
    List<ItemCategory>? itemCategories,
  }) async {
    try {
      emit(
        state.copyWith(
          loadingFirestore: true,
        ),
      );
      for (final group in groupCategoryHistory) {
        final groupCategory = GroupCategory(
          id: group.groupId,
          groupName: group.groupName,
          type: group.type,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          iconPath: null,
          hexColor: group.hexColor,
        );

        final result = await _insertGroupCategory(
          groupCategory: groupCategory,
          groupCategories: groupCategories,
          fromInitial: false,
          fromSync: false,
        );

        if (result) {
          final result =
              await _insertGroupCategoryHistoryToFirestore.call(group);

          result.fold(
            (l) => emit(
              state.copyWith(
                insertGroupCategoryHistorySuccess: false,
                loadingFirestore: false,
              ),
            ),
            (r) => emit(
              state.copyWith(
                insertGroupCategoryHistorySuccess: true,
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              insertGroupCategoryHistorySuccess: false,
              errorMessage: 'Failed to insert group category',
              loadingFirestore: false,
            ),
          );
        }
      }

      // save item category to db
      if (state.insertGroupCategoryHistorySuccess) {
        for (final itemCategory in itemCategoriesParams) {
          final result = await _insertItemCategoryFire(
            itemCategory: ItemCategory(
              id: itemCategory.itemId,
              categoryName: itemCategory.name,
              type: itemCategory.type,
              createdAt: itemCategory.createdAt,
              updatedAt: itemCategory.updatedAt,
              iconPath: itemCategory.iconPath,
              hexColor: itemCategory.hexColor,
            ),
            itemCategories: itemCategories,
            fromInitial: false,
            fromSync: false,
          );

          if (result) {
            final result =
                await _insertItemCategoryHistoryToFirestore.call(itemCategory);

            result.fold(
              (l) => emit(
                state.copyWith(
                  insertItemHistoryFireSuccess: false,
                  loadingFirestore: false,
                ),
              ),
              (r) => emit(
                state.copyWith(
                  insertItemHistoryFireSuccess: true,
                  loadingFirestore: false,
                ),
              ),
            );
          }
        }
      }
    } on Exception {
      emit(
        state.copyWith(
          insertGroupCategoryHistorySuccess: false,
          errorMessage: 'Failed to insert group category',
          loadingFirestore: false,
        ),
      );
    }
  }

  Future<bool> _insertItemCategoryFire({
    required ItemCategory itemCategory,
    required bool fromInitial,
    required bool fromSync,
    List<ItemCategory>? itemCategories,
  }) async {
    if (fromInitial || fromSync) {
      final result = await _insertItemCategoryToFirestore.call(itemCategory);

      return result.fold(
        (l) => false,
        (r) => true,
      );
    }

    if (itemCategories != null) {
      final exist =
          itemCategories.any((element) => element.id == itemCategory.id);

      if (exist) {
        return true;
      } else {
        final result = await _insertItemCategoryToFirestore.call(itemCategory);

        return result.fold(
          (l) => false,
          (r) => true,
        );
      }
    } else {
      return true;
    }
  }

  Future<bool> _insertGroupCategory({
    required GroupCategory groupCategory,
    required bool fromInitial,
    required bool fromSync,
    List<GroupCategory>? groupCategories,
  }) async {
    if (fromInitial || fromSync) {
      final result = await _insertGroupCategoryToFirestore.call(groupCategory);

      return result.fold(
        (l) => false,
        (r) => true,
      );
    }

    if (groupCategories != null) {
      final exist =
          groupCategories.any((element) => element.id == groupCategory.id);

      if (exist) {
        return true;
      } else {
        final result =
            await _insertGroupCategoryToFirestore.call(groupCategory);

        return result.fold(
          (l) => false,
          (r) => true,
        );
      }
    } else {
      return true;
    }
  }

  Future<void> insertItemCategoryHistoryToFirestore({
    required ItemCategoryHistory itemCategoryHistory,
    required ItemCategory itemCategory,
    required List<ItemCategory> itemCategories,
  }) async {
    try {
      emit(
        state.copyWith(
          loadingFirestore: true,
        ),
      );

      final result = await _insertItemCategoryFire(
        itemCategory: itemCategory,
        itemCategories: itemCategories,
        fromInitial: false,
        fromSync: false,
      );

      if (result) {
        final result = await _insertItemCategoryHistoryToFirestore.call(
          itemCategoryHistory,
        );

        result.fold(
          (l) => emit(
            state.copyWith(
              insertItemHistoryFireSuccess: false,
              errorMessage: l.message,
              initial: false,
              loadingFirestore: false,
            ),
          ),
          (r) => emit(
            state.copyWith(
              insertItemHistoryFireSuccess: true,
              initial: false,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            insertItemHistoryFireSuccess: false,
            errorMessage: 'Failed to insert item category',
            initial: false,
            loadingFirestore: false,
          ),
        );
      }
    } on Exception {
      emit(
        state.copyWith(
          insertItemHistoryFireSuccess: false,
          errorMessage: 'Failed to insert item category',
          initial: false,
          loadingFirestore: false,
        ),
      );
    }
  }

  Future<bool> _updateUserFirestore(UserIntelli user) async {
    final result = await _updateUserFire.call(user);

    return result.fold(
      (l) => false,
      (r) => true,
    );
  }

  Future<void> updateItemCategoryHistoryFirestore({
    required ItemCategoryHistory itemCategoryHistory,
    required ItemCategory itemCategoryUpdated,
  }) async {
    emit(
      state.copyWith(
        loadingFirestore: true,
      ),
    );

    final updateItemResult = await _updateItemCategory(itemCategoryUpdated);

    if (updateItemResult) {
      final result =
          await _updateItemCategoryHistoryFirestore(itemCategoryHistory);

      result.fold(
        (failure) => emit(
          state.copyWith(
            errorMessage: failure.message,
            loadingFirestore: false,
          ),
        ),
        (unit) => emit(
          state.copyWith(
            updateItemHistoryFireSuccess: true,
            loadingFirestore: false,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          updateItemHistoryFireSuccess: false,
          errorMessage: 'Failed to update item category',
          loadingFirestore: false,
        ),
      );
    }
  }

  Future<bool> _updateItemCategory(ItemCategory itemCategory) async {
    final result = await _updateItemCategoryFirestore(itemCategory);

    return result.fold(
      (l) => false,
      (r) => true,
    );
  }

  Future<void> insertItemCategoryTransactionToFirestore({
    required ItemCategoryTransaction itemCategoryTransaction,
    required Account selectedAccount,
    required double amount,
  }) async {
    emit(
      state.copyWith(
        loadingFirestore: true,
      ),
    );

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

    final resultAddAccountHisto =
        await _insertAccountHistoryFire(accountHistory);

    if (!resultAddAccountHisto) {
      _emitInsertTransactionResult(success: false);
      return;
    }

    final updateAccResult = await _updateAccount(
      selectedAccount,
      isExpense: isExpense,
      amount: amount,
    );

    if (!updateAccResult) {
      _emitInsertTransactionResult(success: false);
      return;
    }

    final result =
        await _insertItemCategoryTransaction(itemCategoryTransaction);
    result.fold(
      (failure) => _emitInsertTransactionResult(success: false),
      (_) => _emitInsertTransactionResult(success: true),
    );
  }

  void _emitInsertTransactionResult({required bool success}) {
    emit(
      state.copyWith(
        loadingFirestore: false,
        insertItemCategoryTransactionSuccess: success,
      ),
    );
  }

  Future<bool> _insertAccountHistoryFire(AccountHistory accountHistory) async {
    final result = await _insertAccountHistoryFirestore(accountHistory);

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

    final result = await _updateAccountFirestore(updatedAccount);

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  Future<void> insertAccountToFirestore({
    required Account account,
  }) async {
    emit(state.copyWith(loadingFirestore: true));
    final result = await _insertAccountFirestore(account);

    result.fold(
      (failure) => emit(
        state.copyWith(
          loadingFirestore: false,
          insertAccountSuccess: false,
        ),
      ),
      (_) => emit(
        state.copyWith(
          loadingFirestore: false,
          insertAccountSuccess: true,
        ),
      ),
    );
  }

  Future<void> updateAccountToFirestore({
    required Account account,
  }) async {
    emit(state.copyWith(loadingFirestore: true));
    final result = await _updateAccountFirestore(account);

    result.fold(
      (failure) => emit(
        state.copyWith(
          loadingFirestore: false,
          updateAccountSuccess: false,
        ),
      ),
      (_) => emit(
        state.copyWith(
          loadingFirestore: false,
          updateAccountSuccess: true,
        ),
      ),
    );
  }

  Future<void> transferAccountFirestore({
    required Account updatedFirstAccount,
    required Account updatedSecondAccount,
  }) async {
    emit(state.copyWith(loadingFirestore: true));
    final updateFirstAccountResult =
        await _updateFirstAccount(updatedFirstAccount);

    if (updateFirstAccountResult) {
      final result = await _updateAccountFirestore(updatedSecondAccount);

      result.fold(
        (failure) => emit(
          state.copyWith(
            loadingFirestore: false,
            transferSuccess: false,
          ),
        ),
        (_) => emit(
          state.copyWith(
            transferSuccess: true,
            loadingFirestore: false,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          loadingFirestore: false,
          transferSuccess: false,
        ),
      );
    }
  }

  Future<bool> _updateFirstAccount(Account firstAccount) async {
    final result = await _updateAccountFirestore(firstAccount);

    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }
}
