import 'dart:async';
import 'package:budget_intelli/features/google_generative_ai/google_generative_ai.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  factory DatabaseHelper() => _instance;

  DatabaseHelper._();
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'chat.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            role TEXT,
            messageIndex INTEGER,
            chatId TEXT
          )
          ''');
      },
    );
  }

  Future<int> insertMessage(Message message) async {
    final db = await database;
    return db.insert('messages', message.toJson());
  }

  Future<List<Message>> getMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('messages');
    return List.generate(maps.length, (i) {
      return Message(
        text: maps[i]['text'] as String,
        role: maps[i]['role'] as String,
        messageIndex: maps[i]['messageIndex'] as int,
        chatId: maps[i]['chatId'] as String,
      );
    });
  }

  // group by chatId
  Future<List<Message>> getMessagesByChatId(String chatId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
    );
    return List.generate(maps.length, (i) {
      return Message(
        text: maps[i]['text'] as String,
        role: maps[i]['role'] as String,
        messageIndex: maps[i]['messageIndex'] as int,
        chatId: maps[i]['chatId'] as String,
      );
    });
  }

  // group by chatId and insert it in one list List<List<Message>>
  Future<List<List<Message>>?> getMessagesGroupByChatId() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('messages');
    final chatIds = maps.map((e) => e['chatId'] as String).toSet().toList();
    final messagesGroupByChatId = <List<Message>>[];
    for (final chatId in chatIds) {
      final List<Map<String, dynamic>> messagesByChatId = await db.query(
        'messages',
        where: 'chatId = ?',
        whereArgs: [chatId],
      );
      messagesGroupByChatId.add(
        List.generate(messagesByChatId.length, (i) {
          return Message(
            text: messagesByChatId[i]['text'] as String,
            role: messagesByChatId[i]['role'] as String,
            messageIndex: messagesByChatId[i]['messageIndex'] as int,
            chatId: messagesByChatId[i]['chatId'] as String,
          );
        }),
      );
    }
    return messagesGroupByChatId;
  }

  Future<int> deleteMessage(int id) async {
    final db = await database;
    return db.delete('messages', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
