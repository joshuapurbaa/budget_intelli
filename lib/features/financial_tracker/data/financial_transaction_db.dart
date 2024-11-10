import 'dart:convert';

import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';
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
            amount REAL NOT NULL,
            date TEXT NOT NULL,
            type TEXT NOT NULL,
            category_name TEXT NOT NULL,
            account_name TEXT NOT NULL,
            account_id TEXT NOT NULL,
            category_id TEXT NOT NULL,
            transaction_location TEXT,
            picture BLOB,
            member_id TEXT NOT NULL,
            member_name TEXT NOT NULL
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
      param.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FinancialTransaction>> getAllFinancialTransaction() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'FinancialTransaction',
      orderBy: 'date DESC',
    );
    return List.generate(
      maps.length,
      (i) {
        return FinancialTransaction.fromMap(maps[i]);
      },
    );
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
      param.toMapDb(),
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

  // get all transactions by month and year
  Future<List<FinancialTransaction>> getAllFinancialTransactionByMonthYear({
    required String month,
    required String year,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'FinancialTransaction',
      where: 'strftime("%m", date) = ? AND strftime("%Y", date) = ?',
      whereArgs: [month, year],
      orderBy: 'date DESC',
    );

    // Salin setiap elemen dalam maps ke list baru agar dapat dimodifikasi
    final modifiableMaps = maps.map((map) {
      final newMap = Map<String, dynamic>.from(map); // Salin map ke objek baru
      if (newMap['transaction_location'] is String) {
        try {
          newMap['transaction_location'] =
              jsonDecode(newMap['transaction_location'] as String);
        } catch (e) {
          debugPrint('Failed to parse transaction_location for map: $map');
        }
      }
      return newMap;
    }).toList();

    return List.generate(
      modifiableMaps.length,
      (i) {
        return FinancialTransaction.fromMap(modifiableMaps[i]);
      },
    );
  }
}
