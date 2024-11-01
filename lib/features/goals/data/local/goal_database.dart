import 'package:budget_intelli/features/goals/goals_barrel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GoalDatabase {
  factory GoalDatabase() => _instance;

  GoalDatabase._();
  static final GoalDatabase _instance = GoalDatabase._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'goals.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Goals (
            id TEXT PRIMARY KEY,
            goal_name TEXT NOT NULL,
            goal_amount TEXT NOT NULL,
            start_goal_date TEXT NOT NULL,
            end_goal_date TEXT NOT NULL,
            remaining_amount TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            per_day_amount TEXT NOT NULL,
            per_month_amount TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE GoalsHistory (
            id TEXT PRIMARY KEY,
            goal_id TEXT NOT NULL,
            saved_amount TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            FOREIGN KEY (goal_id) REFERENCES Goals(id)
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> insertGoal(GoalModel goal) async {
    final db = await database;
    await db.insert(
      'Goals',
      goal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<GoalModel?> getGoalById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Goals',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    } else {
      return GoalModel.fromMap(maps.first);
    }
  }

  Future<List<GoalModel>> getAllGoals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Goals',
      orderBy: 'updated_at DESC',
    );

    if (maps.isEmpty) {
      return [];
    } else {
      return List<GoalModel>.from(
        maps.map(
          GoalModel.fromMap,
        ),
      );
    }
  }

  Future<void> updateGoal(GoalModel goal) async {
    final db = await database;
    await db.update(
      'Goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  Future<void> deleteGoal(String id) async {
    final db = await database;
    await db.delete(
      'Goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertGoalHistory(GoalHistoryModel goalHistory) async {
    final db = await database;
    await db.insert(
      'GoalsHistory',
      goalHistory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<GoalHistoryModel?> getGoalHistoryById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'GoalsHistory',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    } else {
      return GoalHistoryModel.fromMap(maps.first);
    }
  }

  Future<List<GoalHistoryModel>> getAllGoalsHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'GoalsHistory',
      orderBy: 'updated_at DESC',
    );

    if (maps.isEmpty) {
      return [];
    } else {
      return List<GoalHistoryModel>.from(
        maps.map(
          GoalHistoryModel.fromMap,
        ),
      );
    }
  }

  Future<List<GoalHistoryModel>> getGoalsHistoryByGoalId(String goalId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'GoalsHistory',
      orderBy: 'updated_at DESC',
      where: 'goal_id = ?',
      whereArgs: [goalId],
    );

    if (maps.isEmpty) {
      return [];
    } else {
      return List<GoalHistoryModel>.from(
        maps.map(
          GoalHistoryModel.fromMap,
        ),
      );
    }
  }

  Future<void> updateGoalHistory(GoalHistoryModel goalHistory) async {
    final db = await database;
    await db.update(
      'GoalsHistory',
      goalHistory.toMap(),
      where: 'id = ?',
      whereArgs: [goalHistory.id],
    );
  }

  Future<void> deleteGoalHistory(String id) async {
    final db = await database;
    await db.delete(
      'GoalsHistory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
