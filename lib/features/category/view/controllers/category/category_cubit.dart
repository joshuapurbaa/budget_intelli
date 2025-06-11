import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({
    required UpdateItemCategoryHistoryUsecase updateItemCategoryToDB,
    required GetItemCategoryTransactionsByItemId getItemCategoryTransactions,
    required DeleteItemCategoryTransactionById deleteItemCategoryTransaction,
    required DeleteItemCategoryHistoryById deleteItemCategory,
    required DeleteGroupCategoryById deleteGroupCategory,
    required DeleteItemCategoryTransactionByItemId
        deleteItemCategoryTransactionByItemId,
    required DeleteCategoryTransactionByGroupId
        deleteCategoryTransactionByGroupId,
    required DeleteItemCategoryHistoryByGroupId deleteItemCategoryByGroupId,
    required InsertGroupCategoryHistoryUsecase insertGroupCategoryHistory,
    required InsertItemCategoryHistoriesUsecase insertItemCategoryHistory,
    required DeleteBudgetById deleteBudgetById,
    required GetGroupCategoryHistoryById getOnlyGroupCategoryById,
    required GetGroupCategoriesUsecase getGroupCategoriesUsecase,
    required GetItemCategoriesUsecase getItemCategoriesUsecase,
    required GetItemCategoryHistoriesByBudgetId
        getItemCategoryHistoriesByBudgetId,
    required GetGroupCategoryHistoriesUsecase getGroupCategoryHistoriesUsecase,
    required InsertItemCategoryUsecase insertItemCategoryUsecase,
    required GetGroupCategoryHistoryByBudgetId
        getGroupCategoryHistoryByBudgetId,
    required InsertGroupCategoryUsecase insertGroupCategoryUsecase,
    required UpdateItemCategoryUsecase updateItemCategoryUsecase,
    required GetAccountByIdUsecase getAccountByIdUsecase,
    required UpdateGroupCategoryHistoryNoItemCategory
        updateGroupCategoryHistoryUsecase,
    required UpdateGroupCategoryUsecase updateGroupCategoryUsecase,
    required UpdateBudgetUsecase updateBudgetUsecase,
  })  : _updateItemCategoryHistory = updateItemCategoryToDB,
        _getItemCategoryTransactions = getItemCategoryTransactions,
        _deleteItemCategoryTransaction = deleteItemCategoryTransaction,
        _deleteItemCategory = deleteItemCategory,
        _deleteGroupCategory = deleteGroupCategory,
        _deleteItemCategoryTransactionByItemId =
            deleteItemCategoryTransactionByItemId,
        _deleteCategoryTransactionByGroupId =
            deleteCategoryTransactionByGroupId,
        _deleteItemCategoryByGroupId = deleteItemCategoryByGroupId,
        _insertGroupCategoryHistory = insertGroupCategoryHistory,
        _insertItemCategoryHistory = insertItemCategoryHistory,
        _deleteBudgetById = deleteBudgetById,
        _getOnlyGroupCategoryById = getOnlyGroupCategoryById,
        _getItemCategoriesUsecase = getItemCategoriesUsecase,
        _getItemCategoryHistoriesByBudgetId =
            getItemCategoryHistoriesByBudgetId,
        _getGroupCategoriesUsecase = getGroupCategoriesUsecase,
        _getGroupCategoryHistoriesUsecase = getGroupCategoryHistoriesUsecase,
        _insertItemCategoryUsecase = insertItemCategoryUsecase,
        _getGroupCategoryHistoryByBudgetId = getGroupCategoryHistoryByBudgetId,
        _insertGroupCategoryUsecase = insertGroupCategoryUsecase,
        _updateItemCategoryUsecase = updateItemCategoryUsecase,
        _getAccountByIdUsecase = getAccountByIdUsecase,
        _updateGroupCategoryHistoryNoItemCategory =
            updateGroupCategoryHistoryUsecase,
        _updateGroupCategoryUsecase = updateGroupCategoryUsecase,
        _updateBudgetUsecase = updateBudgetUsecase,
        super(const CategoryState());

  final UpdateItemCategoryHistoryUsecase _updateItemCategoryHistory;
  final GetItemCategoryTransactionsByItemId _getItemCategoryTransactions;
  final DeleteItemCategoryTransactionById _deleteItemCategoryTransaction;
  final DeleteItemCategoryHistoryById _deleteItemCategory;
  final DeleteGroupCategoryById _deleteGroupCategory;
  final DeleteCategoryTransactionByGroupId _deleteCategoryTransactionByGroupId;
  final DeleteItemCategoryTransactionByItemId
      _deleteItemCategoryTransactionByItemId;
  final DeleteItemCategoryHistoryByGroupId _deleteItemCategoryByGroupId;
  final InsertGroupCategoryHistoryUsecase _insertGroupCategoryHistory;
  final InsertItemCategoryHistoriesUsecase _insertItemCategoryHistory;
  final DeleteBudgetById _deleteBudgetById;
  final GetGroupCategoryHistoryById _getOnlyGroupCategoryById;
  final GetGroupCategoriesUsecase _getGroupCategoriesUsecase;
  final GetGroupCategoryHistoriesUsecase _getGroupCategoryHistoriesUsecase;
  final GetItemCategoriesUsecase _getItemCategoriesUsecase;
  final GetItemCategoryHistoriesByBudgetId _getItemCategoryHistoriesByBudgetId;
  final GetGroupCategoryHistoryByBudgetId _getGroupCategoryHistoryByBudgetId;
  final InsertGroupCategoryUsecase _insertGroupCategoryUsecase;
  final InsertItemCategoryUsecase _insertItemCategoryUsecase;
  final UpdateItemCategoryUsecase _updateItemCategoryUsecase;
  final GetAccountByIdUsecase _getAccountByIdUsecase;
  final UpdateGroupCategoryHistoryNoItemCategory
      _updateGroupCategoryHistoryNoItemCategory;
  final UpdateGroupCategoryUsecase _updateGroupCategoryUsecase;
  final UpdateBudgetUsecase _updateBudgetUsecase;

  void getItemCategoryArgs({
    ItemCategoryHistory? itemCategoryHistory,
    List<GroupCategoryHistory>? groupCategoryHistories,
    Budget? budget,
    bool? addNewItemCategory,
    GroupCategoryHistory? groupCategoryHistory,
    List<Color>? pickerColor,
    List<Color>? currentColor,
    double? lefToBudget,
  }) {
    emit(
      state.copyWith(
        itemCategoryHistory: itemCategoryHistory,
        groupCategoryHistories: groupCategoryHistories,
        budget: budget,
        addNewItemCategory: addNewItemCategory,
        groupCategoryHistory:
            groupCategoryHistory ?? state.groupCategoryHistory,
        pickerColor: pickerColor ?? state.pickerColor,
        currentColor: currentColor ?? state.currentColor,
        leftToBudget: lefToBudget ?? state.leftToBudget,
      ),
    );
  }

  void getItemCategoryTransaction({
    ItemCategoryTransaction? itemCategoryTransaction,
    Budget? budget,
    ItemCategoryHistory? itemCategory,
  }) {
    emit(
      state.copyWith(
        itemCategoryTransaction: itemCategoryTransaction,
        budget: budget,
        itemCategoryHistory: itemCategory,
      ),
    );
  }

  void getBudgetAndGroup({
    Budget? budget,
    List<GroupCategoryHistory>? groupCategoryHistory,
    double? lefToBudget,
  }) {
    emit(
      state.copyWith(
        budget: budget,
        groupCategoryHistories: groupCategoryHistory,
        leftToBudget: lefToBudget,
      ),
    );
  }

  void changeColor({
    int? hexColor,
  }) {
    emit(
      state.copyWith(
        hexColor: hexColor,
      ),
    );
  }

  Future<void> updateItemCategoryHistory({
    required ItemCategoryHistory itemCategoryHistory,
  }) async {
    final itemCategoryUpdated = ItemCategory(
      id: itemCategoryHistory.itemId,
      categoryName: itemCategoryHistory.name,
      type: itemCategoryHistory.type,
      createdAt: itemCategoryHistory.createdAt,
      updatedAt: itemCategoryHistory.updatedAt,
      iconPath: itemCategoryHistory.iconPath,
      hexColor: itemCategoryHistory.hexColor,
    );

    final updateItemResult = await _updateItemCategory(itemCategoryUpdated);

    if (updateItemResult) {
      final result = await _updateItemCategoryHistory(itemCategoryHistory);

      result.fold(
        (failure) => emit(
          state.copyWith(
            failure: failure.message,
            successUpdate: false,
          ),
        ),
        (unit) => emit(
          state.copyWith(
            itemCategoryHistory: itemCategoryHistory,
            itemCategoryParam: itemCategoryUpdated,
            successUpdate: true,
          ),
        ),
      );
    }
  }

  Future<bool> _updateItemCategory(ItemCategory itemCategory) async {
    final result = await _updateItemCategoryUsecase(itemCategory);

    return result.fold(
      (l) => false,
      (r) => true,
    );
  }

  Future<List<ItemCategoryTransaction>> getItemCategoryTransactions({
    required String itemId,
  }) async {
    final result = await _getItemCategoryTransactions(itemId);

    return result.fold((failure) {
      emit(
        state.copyWith(
          failure: failure.message,
          itemCategoryTransactions: [],
        ),
      );
      return [];
    }, (itemCategoryTransactions) {
      emit(
        state.copyWith(
          itemCategoryTransactions: itemCategoryTransactions,
        ),
      );
      return itemCategoryTransactions;
    });
  }

  Future<void> insertItemCategoryHistory({
    required ItemCategoryHistory itemCategoryHistory,
  }) async {
    final itemCategory = ItemCategory(
      id: itemCategoryHistory.itemId,
      categoryName: itemCategoryHistory.name,
      type: itemCategoryHistory.type,
      createdAt: itemCategoryHistory.createdAt,
      updatedAt: itemCategoryHistory.updatedAt,
      iconPath: itemCategoryHistory.iconPath,
      hexColor: itemCategoryHistory.hexColor,
    );

    final result = await _insertItemCategory(itemCategory);

    if (result) {
      final result = await _insertItemCategoryHistory(itemCategoryHistory);

      result.fold(
        (failure) => emit(
          state.copyWith(
            failure: failure.message,
            successInsert: false,
          ),
        ),
        (unit) => emit(
          state.copyWith(
            itemCategoryHistory: itemCategoryHistory,
            successInsert: true,
            itemCategoryParam: itemCategory,
            itemCategoryHistoryParam: itemCategoryHistory,
          ),
        ),
      );
    }
  }

  Future<void> deleteItemCategoryTransaction({
    required String id,
  }) async {
    final result = await _deleteItemCategoryTransaction(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure.message,
          successDeleteTransaction: false,
        ),
      ),
      (unit) => emit(
        state.copyWith(
          successDeleteTransaction: true,
        ),
      ),
    );
  }

  void resetState() {
    emit(
      state.copyWith(
        successUpdate: false,
        successInsert: false,
        successDelete: false,
        successDeleteTransaction: false,
        successDeleteBudget: false,
        insertGroupCategoryHistorySuccess: false,
        successUpdateBudget: false,
      ),
    );
  }

  Future<void> deleteItemCategory({
    required String itemId,
  }) async {
    final result = await _deleteItemCategory(itemId);
    final deleteTransaction =
        await _deleteItemCategoryTransactionByItemId(itemId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure.message,
          successDelete: false,
        ),
      ),
      (unit) {
        deleteTransaction.fold(
          (failure) => emit(
            state.copyWith(
              failure: failure.message,
              successDelete: false,
            ),
          ),
          (unit) => emit(
            state.copyWith(
              successDelete: true,
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteGroupCategory({
    required String id,
  }) async {
    final deleteTransaction = await _deleteCategoryTransactionByGroupId(id);
    final deleteItemCategory = await _deleteItemCategoryByGroupId(id);
    final deleteGroup = await _deleteGroupCategory(id);

    deleteTransaction.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure.message,
          successDelete: false,
        ),
      ),
      (unit) {
        deleteItemCategory.fold(
          (failure) => emit(
            state.copyWith(
              failure: failure.message,
              successDelete: false,
            ),
          ),
          (unit) {
            deleteGroup.fold(
              (failure) => emit(
                state.copyWith(
                  failure: failure.message,
                  successDelete: false,
                ),
              ),
              (unit) => emit(
                state.copyWith(
                  successDelete: true,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _insertGroupCategory(GroupCategory groupCategory) async {
    final groupCategories = state.groupCategories;

    // check if group category already exist in db
    final isExist =
        groupCategories.any((element) => element.id == groupCategory.id);

    if (isExist) {
      return true;
    } else {
      final result = await _insertGroupCategoryUsecase(groupCategory);

      return result.fold(
        (l) => false,
        (r) => true,
      );
    }
  }

  Future<bool> _insertItemCategory(ItemCategory itemCategory) async {
    final itemCategories = state.itemCategories;

    // check if item category already exist in db
    final isExist = itemCategories
        .any((element) => element.categoryName == itemCategory.categoryName);

    if (isExist) {
      return true;
    } else {
      final result = await _insertItemCategoryUsecase(itemCategory);

      return result.fold(
        (l) => false,
        (r) => true,
      );
    }
  }

  Future<void> insertNewGroupCategory({
    required List<GroupCategoryHistory> groupCategoryHistoryParams,
    required List<ItemCategoryHistory> itemCategoryHistoryParams,
  }) async {
    try {
      for (final group in groupCategoryHistoryParams) {
        final groupCategory = GroupCategory(
          id: group.groupId,
          groupName: group.groupName,
          type: group.type,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          iconPath: null,
          hexColor: group.hexColor,
        );

        final result = await _insertGroupCategory(groupCategory);

        if (result) {
          final result = await _insertGroupCategoryHistory.call(group);

          result.fold(
            (l) => emit(
              state.copyWith(
                insertGroupCategoryHistorySuccess: false,
              ),
            ),
            (r) => emit(
              state.copyWith(
                insertGroupCategoryHistorySuccess: true,
              ),
            ),
          );
        }
      }

      // save item category to db
      if (state.insertGroupCategoryHistorySuccess) {
        for (final itemCategory in itemCategoryHistoryParams) {
          final result = await _insertItemCategory(
            ItemCategory(
              id: itemCategory.itemId,
              categoryName: itemCategory.name,
              type: itemCategory.type,
              createdAt: itemCategory.createdAt,
              updatedAt: itemCategory.updatedAt,
              iconPath: itemCategory.iconPath,
              hexColor: itemCategory.hexColor,
            ),
          );

          if (result) {
            final result = await _insertItemCategoryHistory.call(itemCategory);

            result.fold(
              (l) => emit(
                state.copyWith(
                  successInsert: false,
                ),
              ),
              (r) => emit(
                state.copyWith(
                  successInsert: true,
                  groupCategoryHistoriesParam: groupCategoryHistoryParams,
                  itemCategoryHistoriesParam: itemCategoryHistoryParams,
                ),
              ),
            );
          }
        }
      }
    } on Exception catch (_) {
      emit(
        state.copyWith(
          successInsert: false,
        ),
      );
    }
  }

  void getGroupIdDeletedIndex(int index) {
    emit(state.copyWith(groupIdDeletedIndex: index));
  }

  Future<void> deleteBudgetById({
    required String id,
  }) async {
    final deleteTransaction = await _deleteCategoryTransactionByGroupId(id);
    final deleteItemCategory = await _deleteItemCategoryByGroupId(id);
    final deleteGroup = await _deleteGroupCategory(id);
    final deleteBudget = await _deleteBudgetById(id);

    deleteTransaction.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure.message,
          successDeleteBudget: false,
        ),
      ),
      (unit) {
        deleteItemCategory.fold(
          (failure) => emit(
            state.copyWith(
              failure: failure.message,
              successDeleteBudget: false,
            ),
          ),
          (unit) {
            deleteGroup.fold(
              (failure) => emit(
                state.copyWith(
                  failure: failure.message,
                  successDeleteBudget: false,
                ),
              ),
              (unit) {
                deleteBudget.fold(
                  (failure) => emit(
                    state.copyWith(
                      failure: failure.message,
                      successDeleteBudget: false,
                    ),
                  ),
                  (unit) => emit(
                    state.copyWith(
                      successDeleteBudget: true,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<List<ItemCategory>> getItemCategories() async {
    final result = await _getItemCategoriesUsecase(NoParams());
    final itemCategories = <ItemCategory>[];

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure.message,
          itemCategories: [],
        ),
      ),
      (data) {
        emit(
          state.copyWith(
            itemCategories: data,
          ),
        );
        itemCategories.addAll(data);
      },
    );

    return itemCategories;
  }

  Future<List<ItemCategoryHistory>> getItemCategoryHistoriesByBudgetId(
    String budgetId,
  ) async {
    final result = await _getItemCategoryHistoriesByBudgetId(budgetId);

    final itemCategoryHistories = <ItemCategoryHistory>[];

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure.message,
          itemCategoryHistoriesCurrentBudgetId: [],
        ),
      ),
      (history) {
        emit(
          state.copyWith(
            itemCategoryHistoriesCurrentBudgetId: history,
          ),
        );
        itemCategoryHistories.addAll(history);
      },
    );

    return itemCategoryHistories;
  }

  // search item category by name from list item categories
  List<ItemCategory> searchItemCategoryByName({
    required String name,
    required List<ItemCategory> itemCategories,
  }) {
    final searchResult = itemCategories
        .where(
          (element) => element.categoryName.toLowerCase().trim().contains(
                name.toLowerCase().trim(),
              ),
        )
        .toList();

    return searchResult;
  }

  Future<GroupCategoryHistory?> getOnlyGroupCategoryById({
    required String id,
  }) async {
    final result = await _getOnlyGroupCategoryById(id);

    return result.fold(
      (failure) => null,
      (groupCategory) => groupCategory,
    );
  }

  Future<List<GroupCategory>> getGroupCategories() async {
    final result = await _getGroupCategoriesUsecase(NoParams());
    final groupCategories = <GroupCategory>[];

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure.message,
          groupCategories: [],
        ),
      ),
      (data) {
        emit(
          state.copyWith(
            groupCategories: data,
          ),
        );
        groupCategories.addAll(data);
      },
    );

    return groupCategories;
  }

  // search group category by name from list group categories
  List<GroupCategory> searchGroupCategoryByName({
    required String name,
    required List<GroupCategory> groupCategories,
  }) {
    final searchResult = groupCategories
        .where(
          (element) => element.groupName.toLowerCase().trim().contains(
                name.toLowerCase().trim(),
              ),
        )
        .toList();

    emit(
      state.copyWith(searchResultGroupCategory: searchResult),
    );

    return searchResult;
  }

  Future<void> getGroupCategoryHistories() async {
    final result = await _getGroupCategoryHistoriesUsecase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure.message,
          groupCategoryHistories: [],
        ),
      ),
      (groupCategoryHistories) {
        emit(
          state.copyWith(
            groupCategoryHistories: groupCategoryHistories,
          ),
        );
      },
    );
  }

  Future<void> insertItemCategory({
    required ItemCategory itemCategory,
  }) async {
    final result = await _insertItemCategoryUsecase(itemCategory);

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure.message,
          successInsert: false,
        ),
      ),
      (unit) => emit(
        state.copyWith(
          successInsert: true,
        ),
      ),
    );
  }

  Future<List<GroupCategoryHistory>> getGroupCategoryHistoryByBudgetId({
    required String budgetId,
  }) async {
    final result = await _getGroupCategoryHistoryByBudgetId(budgetId);
    final groupCategoryHistories = <GroupCategoryHistory>[];

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure.message,
          groupCategoryHistoriesCurrentBudgetId: [],
        ),
      ),
      (data) {
        emit(
          state.copyWith(
            groupCategoryHistoriesCurrentBudgetId: data,
          ),
        );
        groupCategoryHistories.addAll(data);
      },
    );

    return groupCategoryHistories;
  }

  Future<void> getAccountById({
    required String accountId,
  }) async {
    final result = await _getAccountByIdUsecase(accountId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure.message,
        ),
      ),
      (account) {
        emit(
          state.copyWith(
            account: account,
          ),
        );
      },
    );
  }

  Future<void> updateGroupCategoryHistoryNoItemCategory({
    required GroupCategoryHistory groupCategoryHistory,
  }) async {
    final groupCategory = GroupCategory(
      id: groupCategoryHistory.groupId,
      groupName: groupCategoryHistory.groupName,
      type: groupCategoryHistory.type,
      createdAt: groupCategoryHistory.createdAt,
      updatedAt: groupCategoryHistory.updatedAt,
      iconPath: null,
      hexColor: groupCategoryHistory.hexColor,
    );

    final result = await _updateGroupCategory(groupCategory: groupCategory);

    if (result) {
      final result =
          await _updateGroupCategoryHistoryNoItemCategory(groupCategoryHistory);

      result.fold(
        (failure) => emit(
          state.copyWith(
            failure: failure.message,
            successUpdate: false,
          ),
        ),
        (unit) => emit(
          state.copyWith(
            groupCategoryHistory: groupCategoryHistory,
            successUpdate: true,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          failure: 'Failed to update group category',
          successUpdate: false,
        ),
      );
    }
  }

  Future<bool> _updateGroupCategory({
    required GroupCategory groupCategory,
  }) async {
    final result = await _updateGroupCategoryUsecase(groupCategory);

    return result.fold(
      (l) => false,
      (r) => true,
    );
  }

  Future<void> updateBudget({
    required Budget budget,
  }) async {
    final result = await _updateBudgetUsecase(budget);

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure.message,
          successUpdateBudget: false,
        ),
      ),
      (unit) => emit(
        state.copyWith(
          budget: budget,
          successUpdateBudget: true,
        ),
      ),
    );
  }
}
