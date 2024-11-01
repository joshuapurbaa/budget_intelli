import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class FinancialCategoryHistoryDbApi {
  Future<Unit> deleteFinancialCategoryHistory(String id);
  Future<FinancialCategoryHistory?> getFinancialCategoryHistoryById(String id);
  Future<List<FinancialCategoryHistory>> getFinancialCategoryHistories();
  Future<Unit> insertFinancialCategoryHistory(
    FinancialCategoryHistory financialCategoryHistory,
  );
  Future<Unit> updateFinancialCategoryHistory(
    FinancialCategoryHistory financialCategoryHistory,
  );
}

class FinancialCategoryHistoryDbApiImpl
    implements FinancialCategoryHistoryDbApi {
  FinancialCategoryHistoryDbApiImpl(this.financialCategoryDb);
  final FinancialCategoryDb financialCategoryDb;
  @override
  Future<Unit> deleteFinancialCategoryHistory(String id) async {
    try {
      await financialCategoryDb.database;
      await financialCategoryDb.deleteFinancialCategoryHistory(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<FinancialCategoryHistory>> getFinancialCategoryHistories() async {
    try {
      await financialCategoryDb.database;
      final result = await financialCategoryDb.getFinancialCategoryHistories();

      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<FinancialCategoryHistory?> getFinancialCategoryHistoryById(
    String id,
  ) async {
    try {
      await financialCategoryDb.database;
      final result = await financialCategoryDb.getFinancialCategoryHistory(id);

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
  Future<Unit> insertFinancialCategoryHistory(
    FinancialCategoryHistory financialCategoryHistory,
  ) async {
    try {
      await financialCategoryDb.database;
      await financialCategoryDb
          .insertFinancialCategoryHistory(financialCategoryHistory);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateFinancialCategoryHistory(
    FinancialCategoryHistory financialCategoryHistory,
  ) async {
    try {
      await financialCategoryDb.database;
      await financialCategoryDb
          .updateFinancialCategoryHistory(financialCategoryHistory);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
