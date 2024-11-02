import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FinancialTransactionDb {
  factory FinancialTransactionDb() => _instance;

  FinancialTransactionDb._();

  static final FinancialTransactionDb _instance = FinancialTransactionDb._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'financial_transaction.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE FinancialTransaction (
            id TEXT PRIMARY KEY,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            comment TEXT,
            amount INTEGER NOT NULL,
            date TEXT NOT NULL,
            type TEXT NOT NULL,
            category_name TEXT NOT NULL,
            account_name TEXT NOT NULL,
            account_id TEXT NOT NULL,
            category_id TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> insertFinancialTransaction(FinancialTransaction param) async {
    final db = await database;
    await db.insert(
      'FinancialTransaction',
      param.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FinancialTransaction>> getAllFinancialTransaction() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('FinancialTransaction');
    return List.generate(maps.length, (i) {
      return FinancialTransaction.fromMap(maps[i]);
    });
  }

  Future<FinancialTransaction?> getFinancialTransaction(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'FinancialTransaction',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FinancialTransaction.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updateFinancialTransaction(FinancialTransaction param) async {
    final db = await database;
    await db.update(
      'FinancialTransaction',
      param.toMap(),
      where: 'id = ?',
      whereArgs: [param.id],
    );
  }

  Future<void> deleteFinancialTransaction(String id) async {
    final db = await database;
    await db.delete(
      'FinancialTransaction',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllFinancialTransaction() async {
    final db = await database;
    await db.delete('FinancialTransaction');
  }
}
