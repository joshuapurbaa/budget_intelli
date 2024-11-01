import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BudgetLocalApi {
  // budget
  Future<List<Budget>> getAllBudgets();

  Future<Unit> updateBudget(Budget budget);

  Future<Budget> getBudgetByIdApi({required String budgetId});

  Future<Unit> insertBudget(Budget budget);

  Future<Unit> deleteBudget({required String id});

  // group category history
  Future<List<GroupCategoryHistory>> getGroupCategoryHistories();

  Future<List<GroupCategoryHistory>> getGroupCategoryHistoriesByBudgetId(
    String budgetId,
  );

  Future<Unit> insertGroupCategoryHistory(GroupCategoryHistory params);

  Future<Unit> updateGroupCategoryHistory(
    GroupCategoryHistory groupCategory,
  );

  Future<Unit> updateGroupCategoryHistoryNoItemCategory(
    GroupCategoryHistory groupCategory,
  );

  Future<GroupCategoryHistory> getGroupCategoryHistoryById(String id);

  Future<GroupCategoryHistory> getSingleGroupCategoryHistoryById(
    String id,
  );

  Future<Unit> deleteGroupCategoryHistoryById(String id);

  Future<Unit> deleteGroupCategoryHistoryByBudgetId(String budgetId);

  // group category
  Future<Unit> insertGroupCategory(GroupCategory groupCategory);

  Future<Unit> updateGroupCategory(GroupCategory groupCategory);

  Future<List<GroupCategory>> getGroupCategories();

  // item category history
  Future<Unit> insertItemCategoryHistory(ItemCategoryHistory params);

  Future<ItemCategoryHistory> getItemCategoryHistoryById(String id);

  Future<Unit> updateItemCategoryHistory(ItemCategoryHistory itemCategory);

  Future<List<ItemCategoryHistory>> getItemCategoryHistoryByGroupId({
    required String groupId,
  });

  Future<List<ItemCategoryHistory>> getItemCategoryHistoryByBudgetId({
    required String budgetId,
  });

  Future<Unit> deleteItemCategoryHistoryById({required String id});

  Future<Unit> deleteItemCategoryHistoryByGroupId({required String groupId});

  Future<Unit> deleteItemCategoryHistoryByBudgetId({required String budgetId});

  Future<List<ItemCategoryHistory>> getItemCategoryHistories();

  // item category
  Future<Unit> insertItemCategory(ItemCategory itemCategory);

  Future<Unit> updateItemCategory(ItemCategory itemCategory);

  Future<List<ItemCategory>> getItemCategories();

  // item category transaction
  Future<List<ItemCategoryTransaction>> getItemCategoryTransactionsByItemId(
    String itemId,
  );

  Future<List<ItemCategoryTransaction>> getItemCategoryTransactionsByBudgetId(
    String budgetId,
  );

  Future<Unit> insertItemCategoryTransaction(
    ItemCategoryTransaction params,
  );

  Future<Unit> updateItemCategoryTransaction(
    ItemCategoryTransaction params,
  );

  Future<Unit> deleteItemCategoryTransactionById(String id);

  Future<Unit> deleteItemCategoryTransactionByItemId(String itemId);

  Future<Unit> deleteCategoryTransactionByGroupId(String groupId);

  Future<Unit> deleteCategoryTransactionByBudgetId(String budgetId);

  Future<List<ItemCategoryTransaction>> getAllItemCategoryTransactions();
}

class BudgetLocalApiImpl implements BudgetLocalApi {
  BudgetLocalApiImpl(this.budgetDB);

  final BudgetDatabase budgetDB;

  @override
  Future<Unit> insertGroupCategoryHistory(
    GroupCategoryHistory params,
  ) async {
    try {
      await budgetDB.database;
      await budgetDB.insertGroupCategoryHistory(
        params.toJsonWithoutItemCategories(),
      );
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertItemCategoryHistory(ItemCategoryHistory params) async {
    try {
      await budgetDB.database;

      await budgetDB.insertItemCategoryHistory(
        params.toJson(),
      );
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<GroupCategoryHistory>> getGroupCategoryHistories() async {
    try {
      final groupCategories = <GroupCategoryHistory>[];
      await budgetDB.database;
      final result = await budgetDB.getGroupCategoryHistories();
      for (final item in result) {
        final itemCategories = GroupCategoryHistory.fromJson(item);
        groupCategories.add(itemCategories);
      }
      return groupCategories;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<ItemCategoryHistory> getItemCategoryHistoryById(String id) async {
    try {
      await budgetDB.database;
      final itemCategory = await budgetDB.getItemCategoryHistoryById(id);
      return ItemCategoryHistory.fromJson(itemCategory);
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Budget> getBudgetByIdApi({required String budgetId}) async {
    try {
      await budgetDB.database;
      final result = await budgetDB.getBudgetById(id: budgetId);

      final budgets = Budget.fromJson(result);

      return budgets;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertBudget(Budget budget) async {
    try {
      await budgetDB.database;
      await budgetDB.insertBudget(budget.toJsonDB());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateItemCategoryHistory(
    ItemCategoryHistory itemCategory,
  ) async {
    assert(itemCategory.budgetId != null, 'BudgetId cannot be null');
    try {
      await budgetDB.database;

      await budgetDB.updateItemCategoryHistory(itemCategory);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<ItemCategoryTransaction>> getItemCategoryTransactionsByItemId(
    String itemId,
  ) async {
    try {
      await budgetDB.database;
      final result = await budgetDB.getItemCategoryTransactions(itemId);
      if (result.isEmpty) {
        return [];
      }
      return result.map(ItemCategoryTransaction.fromJson).toList();
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertItemCategoryTransaction(
    ItemCategoryTransaction params,
  ) async {
    try {
      await budgetDB.database;
      await budgetDB.insertItemCategoryTransaction(params.toJson());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<Budget>> getAllBudgets() async {
    try {
      await budgetDB.database;
      final result = await budgetDB.getAllBudgets();

      final budgets = result.map(Budget.fromJson).toList();

      return budgets;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateBudget(Budget budget) async {
    try {
      await budgetDB.database;
      await budgetDB.updateBudget(budget.toJsonDB());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> deleteBudget({required String id}) async {
    try {
      await budgetDB.database;
      await budgetDB.deleteBudget(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> deleteGroupCategoryHistoryById(String id) async {
    try {
      await budgetDB.database;
      await budgetDB.deleteGroupCategoryHistoryById(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> deleteItemCategoryHistoryById({required String id}) async {
    try {
      await budgetDB.database;
      await budgetDB.deleteItemCategoryHistoryById(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> deleteItemCategoryTransactionById(String id) async {
    try {
      await budgetDB.database;
      await budgetDB.deleteItemCategoryTransaction(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<GroupCategoryHistory> getGroupCategoryHistoryById(
    String id,
  ) async {
    try {
      await budgetDB.database;
      final groupCategory = await budgetDB.getGroupCategoryHistoryById(id);

      return GroupCategoryHistory.fromJson(groupCategory);
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<ItemCategoryHistory>> getItemCategoryHistoryByGroupId({
    required String groupId,
  }) async {
    try {
      await budgetDB.database;
      final result = await budgetDB.getItemCategoryHistoryByGroupId(groupId);
      if (result.isEmpty) {
        return [];
      }
      return result.map(ItemCategoryHistory.fromJson).toList();
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateGroupCategoryHistory(
    GroupCategoryHistory groupCategoryHistory,
  ) async {
    try {
      await budgetDB.database;
      await budgetDB.updateGroupCategoryHistory(groupCategoryHistory.toJson());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateItemCategoryTransaction(
    ItemCategoryTransaction params,
  ) async {
    try {
      await budgetDB.database;
      await budgetDB.updateItemCategoryTransaction(params.toJson());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<ItemCategoryTransaction>> getItemCategoryTransactionsByBudgetId(
    String budgetId,
  ) async {
    try {
      await budgetDB.database;
      final result = await budgetDB.getItemCategoryTransactionsByBudgetId(budgetId);
      if (result.isEmpty) {
        return [];
      }
      return result.map(ItemCategoryTransaction.fromJson).toList();
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> deleteItemCategoryTransactionByItemId(String itemId) async {
    try {
      await budgetDB.database;
      await budgetDB.deleteItemCategoryTransactionsByItemId(itemId);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> deleteCategoryTransactionByGroupId(String groupId) async {
    try {
      await budgetDB.database;
      await budgetDB.deleteCategoryTransactionByGroupId(groupId);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> deleteItemCategoryHistoryByGroupId({
    required String groupId,
  }) async {
    try {
      await budgetDB.database;
      await budgetDB.deleteItemCategoryHistoryByGroupId(groupId);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<ItemCategoryHistory>> getItemCategoryHistories() async {
    try {
      await budgetDB.database;
      final result = await budgetDB.getItemCategoryHistories();
      if (result.isEmpty) {
        return [];
      }
      return result.map(ItemCategoryHistory.fromJson).toList();
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<ItemCategoryTransaction>> getAllItemCategoryTransactions() async {
    try {
      await budgetDB.database;
      final result = await budgetDB.getAllItemCategoryTransactions();
      if (result.isEmpty) {
        return [];
      }
      return result.map(ItemCategoryTransaction.fromJson).toList();
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<ItemCategoryHistory>> getItemCategoryHistoryByBudgetId({
    required String budgetId,
  }) async {
    try {
      await budgetDB.database;
      final result = await budgetDB.getItemCategoryHistoryByBudgetId(budgetId);
      if (result.isEmpty) {
        return [];
      }
      return result.map(ItemCategoryHistory.fromJson).toList();
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> deleteCategoryTransactionByBudgetId(String budgetId) async {
    try {
      await budgetDB.database;
      await budgetDB.deleteItemCategoryTransactionsByBudgetId(budgetId);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> deleteGroupCategoryHistoryByBudgetId(String budgetId) async {
    try {
      await budgetDB.database;
      await budgetDB.deleteGroupCategoryByBudgetId(budgetId);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> deleteItemCategoryHistoryByBudgetId({
    required String budgetId,
  }) async {
    try {
      await budgetDB.database;
      await budgetDB.deleteItemCategoryHistoryByBudgetId(budgetId);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<GroupCategoryHistory> getSingleGroupCategoryHistoryById(
    String id,
  ) async {
    try {
      await budgetDB.database;
      final groupCategory = await budgetDB.getGroupCategoryHistoryById(id);
      return GroupCategoryHistory.fromJsonWithoutItemCategories(
        groupCategory,
      );
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<GroupCategory>> getGroupCategories() async {
    try {
      final groupCategories = <GroupCategory>[];
      await budgetDB.database;
      final result = await budgetDB.getGroupCategories();
      for (final item in result) {
        final itemCategories = GroupCategory.fromJson(item);
        groupCategories.add(itemCategories);
      }
      return groupCategories;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<ItemCategory>> getItemCategories() async {
    try {
      final itemCategories = <ItemCategory>[];
      await budgetDB.database;
      final result = await budgetDB.getItemCategories();
      for (final item in result) {
        final itemCategory = ItemCategory.fromJson(item);
        itemCategories.add(itemCategory);
      }
      return itemCategories;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertGroupCategory(GroupCategory groupCategory) async {
    try {
      await budgetDB.database;
      await budgetDB.insertGroupCategory(groupCategory.toJson());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertItemCategory(ItemCategory itemCategory) async {
    try {
      await budgetDB.database;
      await budgetDB.insertItemCategory(itemCategory.toJson());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateGroupCategory(GroupCategory groupCategory) async {
    try {
      await budgetDB.database;
      await budgetDB.updateGroupCategory(groupCategory.toJson());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateItemCategory(ItemCategory itemCategory) async {
    try {
      await budgetDB.database;
      await budgetDB.updateItemCategory(itemCategory.toJson());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<GroupCategoryHistory>> getGroupCategoryHistoriesByBudgetId(
    String budgetId,
  ) async {
    try {
      final groupCategories = <GroupCategoryHistory>[];
      await budgetDB.database;
      final result = await budgetDB.getGroupCategoryHistoriesByBudgetId(budgetId);
      for (final item in result) {
        final itemCategories = GroupCategoryHistory.fromJsonWithoutItemCategories(item);
        groupCategories.add(itemCategories);
      }
      return groupCategories;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateGroupCategoryHistoryNoItemCategory(GroupCategoryHistory groupCategory) async {
    try {
      await budgetDB.database;
      await budgetDB.updateGroupCategoryHistory(groupCategory.toJsonWithoutItemCategories());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
