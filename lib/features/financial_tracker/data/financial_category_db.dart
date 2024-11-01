import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FinancialCategoryDb {
  factory FinancialCategoryDb() => _instance;

  FinancialCategoryDb._();

  static final FinancialCategoryDb _instance = FinancialCategoryDb._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'financial_category.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE FinancialCategory (
            id TEXT PRIMARY KEY,
            category_name TEXT UNIQUE NOT NULL,
            type TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT,
            icon_path TEXT,
            hex_color INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE FinancialCategoryHistory (
            id TEXT PRIMARY KEY,
            category_name TEXT NOT NULL,
            type TEXT NOT NULL,
            category_id TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT,
            hex_color INTEGER NOT NULL,
            FOREIGN KEY (category_id) REFERENCES FinancialCategory(id),
            FOREIGN KEY (category_name) REFERENCES FinancialCategory(category_name),
            FOREIGN KEY (hex_color) REFERENCES FinancialCategory(hex_color)
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> insertFinancialCategory(
    FinancialCategory financialCategory,
  ) async {
    final db = await database;
    await db.insert(
      'FinancialCategory',
      financialCategory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertFinancialCategoryHistory(
    FinancialCategoryHistory financialCategoryHistory,
  ) async {
    final db = await database;
    await db.insert(
      'FinancialCategoryHistory',
      financialCategoryHistory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FinancialCategory>> getFinancialCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('FinancialCategory');
    return List.generate(maps.length, (i) {
      return FinancialCategory.fromMap(maps[i]);
    });
  }

  Future<List<FinancialCategoryHistory>> getFinancialCategoryHistories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('FinancialCategoryHistory');
    return List.generate(maps.length, (i) {
      return FinancialCategoryHistory.fromMap(maps[i]);
    });
  }

  Future<FinancialCategory?> getFinancialCategory(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'FinancialCategory',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FinancialCategory.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<FinancialCategoryHistory?> getFinancialCategoryHistory(
      String id,) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'FinancialCategoryHistory',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FinancialCategoryHistory.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updateFinancialCategory(
    FinancialCategory financialCategory,
  ) async {
    final db = await database;
    await db.update(
      'FinancialCategory',
      financialCategory.toMap(),
      where: 'id = ?',
      whereArgs: [financialCategory.id],
    );
  }

  Future<void> updateFinancialCategoryHistory(
    FinancialCategoryHistory financialCategoryHistory,
  ) async {
    final db = await database;
    await db.update(
      'FinancialCategoryHistory',
      financialCategoryHistory.toMap(),
      where: 'id = ?',
      whereArgs: [financialCategoryHistory.id],
    );
  }

  Future<void> deleteFinancialCategory(String id) async {
    final db = await database;
    await db.delete(
      'FinancialCategory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteFinancialCategoryHistory(String id) async {
    final db = await database;
    await db.delete(
      'FinancialCategoryHistory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllFinancialCategories() async {
    final db = await database;
    await db.delete('FinancialCategory');
  }

  Future<void> deleteAllFinancialCategoryHistories() async {
    final db = await database;
    await db.delete('FinancialCategoryHistory');
  }

  Future<void> deleteAllFinancialCategoryHistoriesByCategoryId(
      String categoryId,) async {
    final db = await database;
    await db.delete(
      'FinancialCategoryHistory',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }
}
