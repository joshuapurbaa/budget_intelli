import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AccountDatabase {
  factory AccountDatabase() => _instance;

  AccountDatabase._();
  static final AccountDatabase _instance = AccountDatabase._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'account.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Account (
            id TEXT PRIMARY KEY,
            name TEXT UNIQUE NOT NULL,
            account_type TEXT NOT NULL,
            amount INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            icon_path TEXT,
            hex_color INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE AccountHistory (
            id TEXT PRIMARY KEY,
            account_id TEXT NOT NULL,
            name TEXT NOT NULL,
            amount INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            icon_path TEXT,
            hex_color INTEGER,
            FOREIGN KEY (account_id) REFERENCES Account(id)
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> insertAccount(Account account) async {
    final db = await database;
    await db.insert(
      'Account',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateAccount(Account account) async {
    final db = await database;
    await db.update(
      'Account',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<void> deleteAccount(String id) async {
    final db = await database;
    await db.delete(
      'Account',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Account>> getAllAccounts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Account',
      orderBy: 'name',
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(
      maps.length,
      (i) => Account.fromMap(maps[i]),
    );
  }

  Future<Account?> getAccount(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Account',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return Account.fromMap(maps.first);
  }

  Future<void> insertAccountHistory(AccountHistory accountHistory) async {
    final db = await database;
    await db.insert(
      'AccountHistory',
      accountHistory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateAccountHistory(AccountHistory accountHistory) async {
    final db = await database;
    await db.update(
      'AccountHistory',
      accountHistory.toMap(),
      where: 'id = ?',
      whereArgs: [accountHistory.id],
    );
  }

  Future<void> deleteAccountHistory(String id) async {
    final db = await database;
    await db.delete(
      'AccountHistory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<AccountHistory>> getAllAccountHistories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'AccountHistory',
      orderBy: 'name',
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(
      maps.length,
      (i) => AccountHistory.fromMap(maps[i]),
    );
  }

  Future<AccountHistory?> getAccountHistory(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'AccountHistory',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return AccountHistory.fromMap(maps.first);
  }
}
