import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SchedulePaymentDatabase {
  factory SchedulePaymentDatabase() => _instance;

  SchedulePaymentDatabase._();
  static final SchedulePaymentDatabase _instance = SchedulePaymentDatabase._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'schedule_payment.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE SchedulePayment (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            status TEXT NOT NULL,
            amount INTEGER NOT NULL,
            due_date TEXT NOT NULL,
            description TEXT,
            created_at TEXT NOT NULL,
            repitition INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE Repetition (
            id TEXT PRIMARY KEY,
            schedule_payment_id TEXT NOT NULL,
            status TEXT NOT NULL,
            due_date TEXT NOT NULL,
            FOREIGN KEY (schedule_payment_id) REFERENCES SchedulePayment(id)
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> insertSchedulePayment(SchedulePayment schedulePayment) async {
    final db = await database;
    await db.insert(
      'SchedulePayment',
      schedulePayment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<SchedulePayment?> getSchedulePaymentById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'SchedulePayment',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    } else {
      return SchedulePayment.fromMap(maps.first);
    }
  }

  Future<List<SchedulePayment>> getAllSchedulePaymentsDb() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'SchedulePayment',
      orderBy: 'created_at DESC',
    );

    if (maps.isEmpty) {
      return [];
    } else {
      return List<SchedulePayment>.from(
        maps.map(
          SchedulePayment.fromMap,
        ),
      );
    }
  }

  Future<void> updateSchedulePayment(SchedulePayment schedulePayment) async {
    final db = await database;
    await db.update(
      'SchedulePayment',
      schedulePayment.toMap(),
      where: 'id = ?',
      whereArgs: [schedulePayment.id],
    );
  }

  Future<void> deleteSchedulePayment(String id) async {
    final db = await database;
    await db.delete(
      'SchedulePayment',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertRepetitions(List<Repetition> repetitions) async {
    final db = await database;

    // Using a batch operation for better performance
    final batch = db.batch();
    for (final element in repetitions) {
      batch.insert(
        'Repetition',
        element.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Repetition>> getRepetitionsBySchedulePaymentId(
    String schedulePaymentId,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Repetition',
      where: 'schedule_payment_id = ?',
      whereArgs: [schedulePaymentId],
    );

    if (maps.isEmpty) {
      return [];
    } else {
      return List<Repetition>.from(
        maps.map(Repetition.fromMap),
      );
    }
  }

  // Insert a Repetition
  Future<void> insertRepetition(Repetition repetition) async {
    final db = await database;
    await db.insert(
      'Repetition',
      repetition.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Update a Repetition
  Future<void> updateRepetition(Repetition repetition) async {
    final db = await database;
    await db.update(
      'Repetition',
      repetition.toMap(),
      where: 'id = ?',
      whereArgs: [repetition.id],
    );
  }

// Delete a Repetition
  Future<void> deleteRepetition(String id) async {
    final db = await database;
    await db.delete(
      'Repetition',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Get a single Repetition by ID
  Future<Repetition?> getRepetitionById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Repetition',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Repetition.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
