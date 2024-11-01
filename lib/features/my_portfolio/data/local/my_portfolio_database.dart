import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyPortfolioDatabase {
  factory MyPortfolioDatabase() => _instance;

  MyPortfolioDatabase._();
  static final MyPortfolioDatabase _instance = MyPortfolioDatabase._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'my_portfolio.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE MyPortfolio (
            id TEXT PRIMARY KEY,
            stock_symbol TEXT NOT NULL,
            company_name TEXT NOT NULL,
            buy_price REAL NOT NULL,
            lot INTEGER NOT NULL,
            stop_loss REAL NOT NULL,
            take_profit REAL,
            buy_date TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            buy_reason TEXT NOT NULL,
            close_price REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> insertMyPortfolio(MyPortfolioModel myPortfolio) async {
    final db = await database;
    await db.insert(
      'MyPortfolio',
      myPortfolio.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<MyPortfolioModel?> getMyPortfolioById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'MyPortfolio',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    } else {
      return MyPortfolioModel.fromMap(maps.first);
    }
  }

  Future<List<MyPortfolioModel>> getMyPortfolioList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'MyPortfolio',
      orderBy: 'updated_at DESC',
    );

    if (maps.isEmpty) {
      return [];
    } else {
      return List<MyPortfolioModel>.from(
        maps.map(
          MyPortfolioModel.fromMap,
        ),
      );
    }
  }

  Future<void> updateMyPortfolio(MyPortfolioModel myPortfolio) async {
    final db = await database;
    await db.update(
      'MyPortfolio',
      myPortfolio.toMap(),
      where: 'id = ?',
      whereArgs: [myPortfolio.id],
    );
  }

  Future<void> deleteMyPortfolioById(String id) async {
    final db = await database;
    await db.delete(
      'MyPortfolio',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
