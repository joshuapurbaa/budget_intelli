import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MemberDb {
  factory MemberDb() => _instance;

  MemberDb._();

  static final MemberDb _instance = MemberDb._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'Member.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Member (
            id TEXT PRIMARY KEY,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            name TEXT NOT NULL,
            icon_path TEXT NOT NULL,
            icon BLOB NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> insertMember(Member param) async {
    final db = await database;
    await db.insert(
      'Member',
      param.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Member>> getAllMember() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Member');
    return List.generate(maps.length, (i) {
      return Member.fromMap(maps[i]);
    });
  }

  Future<Member?> getMember(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Member',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Member.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updateMember(Member param) async {
    final db = await database;
    await db.update(
      'Member',
      param.toMap(),
      where: 'id = ?',
      whereArgs: [param.id],
    );
  }

  Future<void> deleteMember(String id) async {
    final db = await database;
    await db.delete(
      'Member',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllMember() async {
    final db = await database;
    await db.delete('Member');
  }
}
