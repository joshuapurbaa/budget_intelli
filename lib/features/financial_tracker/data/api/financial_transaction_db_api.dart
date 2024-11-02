import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class FinancialTransactionDbApi {
  Future<Unit> deleteFinancialTransaction(String id);
  Future<FinancialTransaction?> getFinancialTransaction(String id);
  Future<List<FinancialTransaction>> getAllFinancialTransaction();
  Future<Unit> insertFinancialTransaction(FinancialTransaction param);
  Future<Unit> updateFinancialTransaction(FinancialTransaction param);
}

class FinancialTransactionDbApiImpl implements FinancialTransactionDbApi {
  FinancialTransactionDbApiImpl(this.db);
  final FinancialTransactionDb db;

  @override
  Future<Unit> deleteFinancialTransaction(String id) async {
    try {
      await db.database;
      await db.deleteFinancialTransaction(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<FinancialTransaction>> getAllFinancialTransaction() async {
    try {
      await db.database;
      final result = await db.getAllFinancialTransaction();
      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<FinancialTransaction?> getFinancialTransaction(String id) async {
    try {
      await db.database;
      final result = await db.getFinancialTransaction(id);
      if (result != null) {
        return result;
      } else {
        return null;
      }
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertFinancialTransaction(FinancialTransaction param) async {
    try {
      await db.database;
      await db.insertFinancialTransaction(param);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateFinancialTransaction(FinancialTransaction param) async {
    try {
      await db.database;
      await db.updateFinancialTransaction(param);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
