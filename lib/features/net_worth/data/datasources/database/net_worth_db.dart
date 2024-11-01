import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NetWorthDatabase {
  factory NetWorthDatabase() => _instance;

  NetWorthDatabase._();
  static final NetWorthDatabase _instance = NetWorthDatabase._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'networth.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Assets (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            amount REAL NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            description TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE Liabilities (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            amount REAL NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            description TEXT
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // insert new asset to the database table
  Future<void> insertAsset(Map<String, dynamic> asset) async {
    final db = await database;
    await db.insert('Assets', asset);
  }

  // update asset in the database table use the id
  Future<void> updateAsset(Map<String, dynamic> asset) async {
    final db = await database;
    await db.update(
      'Assets',
      asset,
      where: 'id = ?',
      whereArgs: [asset['id']],
    );
  }

  // delete asset in the database table use the id
  Future<void> deleteAsset(String id) async {
    final db = await database;
    await db.delete(
      'Assets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // insert new liability to the database table
  Future<void> insertLiability(Map<String, dynamic> liability) async {
    final db = await database;
    await db.insert('Liabilities', liability);
  }

  // update liability in the database table use the id
  Future<void> updateLiability(Map<String, dynamic> liability) async {
    final db = await database;
    await db.update(
      'Liabilities',
      liability,
      where: 'id = ?',
      whereArgs: [liability['id']],
    );
  }

  // delete liability in the database table use the id
  Future<void> deleteLiability(String id) async {
    final db = await database;
    await db.delete(
      'Liabilities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // get all assets from the database table
  Future<List<Map<String, dynamic>>> assets() async {
    final db = await database;
    return db.query('Assets');
  }

  // get all liabilities from the database table
  Future<List<Map<String, dynamic>>> liabilities() async {
    final db = await database;
    return db.query('Liabilities');
  }
}
