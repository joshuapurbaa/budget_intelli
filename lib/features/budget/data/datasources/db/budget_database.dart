import 'package:budget_intelli/core/utils/typedef.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BudgetDatabase {
  factory BudgetDatabase() => _instance;

  BudgetDatabase._();

  static final BudgetDatabase _instance = BudgetDatabase._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'budget.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Budget (
            id TEXT PRIMARY KEY,
            budget_name TEXT NOT NULL,
            created_at TEXT NOT NULL,
            start_date TEXT NOT NULL,
            end_date TEXT NOT NULL,
            is_active INTEGER NOT NULL,
            is_monthly INTEGER NOT NULL,
            is_weekly INTEGER NOT NULL,
            month INTEGER NOT NULL,
            year INTEGER NOT NULL,
            total_plan_expense INTEGER NOT NULL,
            total_plan_income INTEGER NOT NULL,
            total_actual_expense INTEGER,
            total_actual_income INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE GroupCategory (
            id TEXT PRIMARY KEY,
            group_name TEXT UNIQUE NOT NULL,
            type TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT,
            icon_path TEXT,
            hex_color INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE GroupCategoryHistory (
            id TEXT PRIMARY KEY,
            group_name TEXT NOT NULL,
            method TEXT,
            type TEXT NOT NULL,
            budget_id TEXT,
            group_id TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT,
            hex_color INTEGER NOT NULL,
            FOREIGN KEY (budget_id) REFERENCES Budget(id)
            FOREIGN KEY (group_id) REFERENCES GroupCategory(id)
            FOREIGN KEY (hex_color) REFERENCES GroupCategory(hex_color)
          )
        ''');
        await db.execute('''
          CREATE TABLE ItemCategory (
            id TEXT PRIMARY KEY,
            name TEXT UNIQUE NOT NULL,
            type TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT,
            icon_path TEXT,
            hex_color INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE ItemCategoryHistory (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            group_history_id TEXT NOT NULL,
            budget_id TEXT NOT NULL,
            item_id TEXT NOT NULL,
            type TEXT NOT NULL,
            created_at TEXT NOT NULL,
            is_expense INTEGER NOT NULL,
            amount INTEGER,
            total_transactions INTEGER,
            icon_path TEXT,
            hex_color INTEGER,
            updated_at TEXT,
            start_date TEXT,
            end_date TEXT,
            is_favorite INTEGER,
            carry_over_amount INTEGER,
            remaining INTEGER,
            group_name TEXT,
            FOREIGN KEY (group_history_id) REFERENCES GroupCategoryHistory(id)
            FOREIGN KEY (item_id) REFERENCES ItemCategory(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE ItemCategoryTransactions (
            id TEXT PRIMARY KEY,
            item_id TEXT NOT NULL,
            category_name TEXT NOT NULL,
            budget_id TEXT,
            group_history_id TEXT,
            amount INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            account_id TEXT NOT NULL,
            type TEXT NOT NULL,
            updated_at TEXT,
            spend_on TEXT,
            picture BLOB,
            FOREIGN KEY (item_id) REFERENCES ItemCategoryHistory(id)
          )
        ''');
      },
    );
  }

  Future<void> insertBudget(Map<String, dynamic> budgetHistory) async {
    final db = await database;
    await db.insert(
      'Budget',
      budgetHistory,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteBudget(String id) async {
    final db = await database;
    await db.delete(
      'Budget',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateBudget(Map<String, dynamic> budget) async {
    final db = await database;
    return db.update(
      'Budget',
      budget,
      where: 'id = ?',
      whereArgs: [budget['id']],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MapStringDynamic>> getAllBudgets() async {
    final db = await database;
    final List<MapStringDynamic> budgetHistories = await db.query('Budget');
    return budgetHistories;
  }

  Future<MapStringDynamic> getBudgetById({required String id}) async {
    final db = await database;

    final List<MapStringDynamic> budgetHistories = await db.query(
      'Budget',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (budgetHistories.isEmpty) {
      return {};
    }

    final budgetId = budgetHistories.first['id'];

    // Retrieve group categories associated with the budget
    final List<MapStringDynamic> groupCategories = await db.query(
      'GroupCategoryHistory',
      where: 'budget_id = ?',
      whereArgs: [budgetId],
    );

    final itemCategories = <MapStringDynamic>[];

    final updatedGroupCategories = <MapStringDynamic>[];

    // Retrieve item categories for each group category
    for (final groupCategory in groupCategories) {
      final groupId = groupCategory['id'];
      final matchingItems = await db.query(
        'ItemCategoryHistory',
        where: 'group_history_id = ?',
        whereArgs: [groupId],
      );
      itemCategories.addAll(matchingItems);
    }

    // Update each group category with its associated item categories
    for (final groupCategory in groupCategories) {
      final updatedGroupCategory = MapStringDynamic.from(groupCategory);
      final matchingItems = itemCategories
          .where((item) => item['group_history_id'] == groupCategory['id'])
          .toList();
      updatedGroupCategory['item_category_history'] = matchingItems;
      updatedGroupCategories.add(updatedGroupCategory);
    }

    MapStringDynamic? budgets;

    // Update each budget history with its associated group categories
    for (final budgetHistory in budgetHistories) {
      final updatedBudgetHistory = MapStringDynamic.from(budgetHistory);
      final matchingGroups = updatedGroupCategories
          .where((group) => group['budget_id'] == budgetHistory['id'])
          .toList();
      updatedBudgetHistory['group_category_history'] = matchingGroups;
      budgets = updatedBudgetHistory;
    }

    if (budgets == null) {
      return {};
    }

    return budgets;
  }

  Future<void> insertGroupCategoryHistory(
    Map<String, dynamic> groupCategory,
  ) async {
    final db = await database;
    await db.insert(
      'GroupCategoryHistory',
      groupCategory,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MapStringDynamic>> getGroupCategoryHistories() async {
    final db = await database;
    final List<MapStringDynamic> groupCategories =
        await db.query('GroupCategoryHistory');
    final List<MapStringDynamic> itemCategories =
        await db.query('ItemCategoryHistory');
    final updatedGroupCategoryHistories = <MapStringDynamic>[];

    for (final groupCategory in groupCategories) {
      final updatedGroupCategory = MapStringDynamic.from(groupCategory);
      final matchingItems = itemCategories
          .where((item) => item['group_history_id'] == groupCategory['id'])
          .toList();
      updatedGroupCategory['item_category_history'] = matchingItems;
      updatedGroupCategoryHistories.add(updatedGroupCategory);
    }

    return updatedGroupCategoryHistories;
  }

  Future<List<MapStringDynamic>> getGroupCategoryHistoriesByBudgetId(
    String budgetId,
  ) async {
    final db = await database;
    final List<MapStringDynamic> groupCategories = await db.query(
      'GroupCategoryHistory',
      where: 'budget_id = ?',
      whereArgs: [budgetId],
    );
    return groupCategories;
  }

  /// update group category
  /// using: id, group_name, method, type, budget_id
  Future<void> updateGroupCategoryHistory(
    Map<String, dynamic> groupCategoryHistory,
  ) async {
    final db = await database;
    await db.update(
      'GroupCategoryHistory',
      groupCategoryHistory,
      where: 'id = ?',
      whereArgs: [groupCategoryHistory['id']],
    );
  }

  /// get group category by id
  /// using: id
  Future<Map<String, dynamic>> getGroupCategoryHistoryById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> groupCategories = await db.query(
      'GroupCategoryHistory',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (groupCategories.isEmpty) {
      return {};
    }

    return groupCategories.first;
  }

  /// delete group category by id
  /// using: id
  Future<void> deleteGroupCategoryHistoryById(String id) async {
    final db = await database;
    await db.delete(
      'GroupCategoryHistory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// delete group category by budget id
  /// using: budget_id
  Future<int> deleteGroupCategoryByBudgetId(String budgetId) async {
    final db = await database;
    return db.delete(
      'GroupCategoryHistory',
      where: 'budget_id = ?',
      whereArgs: [budgetId],
    );
  }

  /// Insert an item category into the database
  /// using: id, name, group_history_id, amount, type, created_at, is_expense must not null
  /// group_history_id is a foreign key to GroupCategoryHistory
  Future<void> insertItemCategoryHistory(
    Map<String, dynamic> itemCategory,
  ) async {
    final db = await database;
    await db.insert(
      'ItemCategoryHistory',
      itemCategory,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update an item category in the database
  /// using item category model with id
  Future<void> updateItemCategoryHistory(
    ItemCategoryHistory itemCategory,
  ) async {
    final db = await database;
    final itemCategoryMap = itemCategory.toJson();
    await db.update(
      'ItemCategoryHistory',
      itemCategoryMap,
      where: 'id = ?',
      whereArgs: [itemCategoryMap['id']],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// get item category by id
  /// using: id
  Future<Map<String, dynamic>> getItemCategoryHistoryById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> itemCategories = await db.query(
      'ItemCategoryHistory',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (itemCategories.isEmpty) {
      return {};
    }

    return itemCategories.first;
  }

  /// get item categories by group id
  /// using: group_history_id
  Future<List<MapStringDynamic>> getItemCategoryHistoryByGroupId(
    String groupId,
  ) async {
    final db = await database;
    final List<MapStringDynamic> itemCategories = await db.query(
      'ItemCategoryHistory',
      where: 'group_history_id = ?',
      whereArgs: [groupId],
    );
    return itemCategories;
  }

  /// get item categories by budget id
  /// using: budget_id
  Future<List<MapStringDynamic>> getItemCategoryHistoryByBudgetId(
    String budgetId,
  ) async {
    final db = await database;
    final List<MapStringDynamic> itemCategories = await db.query(
      'ItemCategoryHistory',
      where: 'budget_id = ?',
      whereArgs: [budgetId],
    );
    return itemCategories;
  }

  /// get all item categories
  /// Retrieves all item categories from the database.
  /// Returns a list of all item categories.
  /// If no item categories are found, an empty list is returned.
  Future<List<MapStringDynamic>> getItemCategoryHistories() async {
    final db = await database;
    final List<MapStringDynamic> itemCategories = await db.query(
      'ItemCategoryHistory',
      orderBy: 'created_at DESC',
    );

    return itemCategories;
  }

  /// delete item category by id
  /// using: id
  Future<void> deleteItemCategoryHistoryById(String id) async {
    final db = await database;
    await db.delete(
      'ItemCategoryHistory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// delete item category by group id
  /// using: group_history_id
  Future<int> deleteItemCategoryHistoryByGroupId(String groupId) async {
    final db = await database;
    return db.delete(
      'ItemCategoryHistory',
      where: 'group_history_id = ?',
      whereArgs: [groupId],
    );
  }

  /// delete item category by budget id
  /// using: budget_id
  Future<int> deleteItemCategoryHistoryByBudgetId(String budgetId) async {
    final db = await database;
    return db.delete(
      'ItemCategoryHistory',
      where: 'budget_id = ?',
      whereArgs: [budgetId],
    );
  }

  /// Insert an item history into the database
  /// using: id, item_id, amount, created_at
  /// item_id is a foreign key to ItemCategoryHistory
  Future<void> insertItemCategoryTransaction(
    Map<String, dynamic> categoryTransaction,
  ) async {
    final db = await database;
    await db.insert(
      'ItemCategoryTransactions',
      categoryTransaction,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// get item category transactions
  /// using: item_id
  /// Retrieves the transactions for a given item category from the database.
  /// The [itemId] parameter specifies the item category for which the transactions should be retrieved.
  /// Returns a list of transactions for the given item category.
  /// If no transactions are found for the given item category, an empty list is returned.
  Future<List<MapStringDynamic>> getItemCategoryTransactions(
    String itemId,
  ) async {
    final db = await database;
    final List<MapStringDynamic> itemCategoryTransactions = await db.query(
      'ItemCategoryTransactions',
      where: 'item_id = ?',
      whereArgs: [itemId],
      orderBy: 'created_at DESC',
    );
    return itemCategoryTransactions;
  }

  /// get all item category transactions
  /// Retrieves all transactions from the database.
  /// Returns a list of all transactions.
  /// If no transactions are found, an empty list is returned.
  Future<List<MapStringDynamic>> getAllItemCategoryTransactions() async {
    final db = await database;
    final List<MapStringDynamic> itemCategoryTransactions = await db.query(
      'ItemCategoryTransactions',
      orderBy: 'created_at DESC',
    );
    return itemCategoryTransactions;
  }

  /// get item category transactions by budget id
  /// using: budget_id
  /// Retrieves the transactions for a given budget from the database.
  /// The [budgetId] parameter specifies the budget for which the transactions should be retrieved.
  /// Returns a list of transactions for the given budget.
  /// If no transactions are found for the given budget, an empty list is returned.
  Future<List<MapStringDynamic>> getItemCategoryTransactionsByBudgetId(
    String budgetId,
  ) async {
    final db = await database;
    final List<MapStringDynamic> itemCategoryTransactions = await db.query(
      'ItemCategoryTransactions',
      where: 'budget_id = ?',
      whereArgs: [budgetId],
      orderBy: 'created_at DESC',
    );
    return itemCategoryTransactions;
  }

  /// update item category transaction
  /// using: id, item_id, amount, created_at, type, updated_at, spend_on, picture
  Future<void> updateItemCategoryTransaction(
    Map<String, dynamic> categoryTransaction,
  ) async {
    final db = await database;
    await db.update(
      'ItemCategoryTransactions',
      categoryTransaction,
      where: 'id = ?',
      whereArgs: [categoryTransaction['id']],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// get item category transaction by id
  /// using: id
  Future<Map<String, dynamic>> getItemCategoryTransactionById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> itemCategoryTransactions = await db.query(
      'ItemCategoryTransactions',
      where: 'id = ?',
      whereArgs: [id],
      orderBy: 'created_at DESC',
    );
    if (itemCategoryTransactions.isEmpty) {
      return {};
    }
    return itemCategoryTransactions.first;
  }

  /// delete item category transaction by id
  /// using: id
  Future<void> deleteItemCategoryTransaction(String id) async {
    final db = await database;
    await db.delete(
      'ItemCategoryTransactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteItemCategoryTransactionsByItemId(String itemId) async {
    final db = await database;
    return db.delete(
      'ItemCategoryTransactions',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
  }

  Future<int> deleteItemCategoryTransactionsByBudgetId(String budgetId) async {
    final db = await database;
    return db.delete(
      'ItemCategoryTransactions',
      where: 'budget_id = ?',
      whereArgs: [budgetId],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<int> deleteCategoryTransactionByGroupId(String groupId) async {
    final db = await database;
    return db.delete(
      'ItemCategoryTransactions',
      where: 'group_history_id = ?',
      whereArgs: [groupId],
    );
  }

  Future<void> insertGroupCategory(
    Map<String, dynamic> groupCategory,
  ) async {
    final db = await database;
    await db.insert(
      'GroupCategory',
      groupCategory,
    );
  }

  Future<List<MapStringDynamic>> getGroupCategories() async {
    final db = await database;
    final List<MapStringDynamic> groupCategories =
        await db.query('GroupCategory');
    return groupCategories;
  }

  Future<void> updateGroupCategory(Map<String, dynamic> groupCategory) async {
    final db = await database;
    await db.update(
      'GroupCategory',
      groupCategory,
      where: 'id = ?',
      whereArgs: [groupCategory['id']],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<MapStringDynamic> getGroupCategoryById(String id) async {
    final db = await database;
    final List<MapStringDynamic> groupCategories = await db.query(
      'GroupCategory',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (groupCategories.isEmpty) {
      return {};
    }

    return groupCategories.first;
  }

  Future<void> deleteGroupCategoryById(String id) async {
    final db = await database;
    await db.delete(
      'GroupCategory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertItemCategory(Map<String, dynamic> itemCategory) async {
    final db = await database;
    await db.insert(
      'ItemCategory',
      itemCategory,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MapStringDynamic>> getItemCategories() async {
    final db = await database;
    final List<MapStringDynamic> itemCategories =
        await db.query('ItemCategory');
    return itemCategories;
  }

  Future<void> updateItemCategory(Map<String, dynamic> itemCategory) async {
    final db = await database;
    await db.update(
      'ItemCategory',
      itemCategory,
      where: 'id = ?',
      whereArgs: [itemCategory['id']],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<MapStringDynamic> getItemCategoryById(String id) async {
    final db = await database;
    final List<MapStringDynamic> itemCategories = await db.query(
      'ItemCategory',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (itemCategories.isEmpty) {
      return {};
    }

    return itemCategories.first;
  }

  Future<void> deleteItemCategoryById(String id) async {
    final db = await database;
    await db.delete(
      'ItemCategory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
