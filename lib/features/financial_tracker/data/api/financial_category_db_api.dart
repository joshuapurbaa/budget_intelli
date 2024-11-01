import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class FinancialCategoryDbApi {
  Future<Unit> deleteFinancialCategory(String id);
  Future<FinancialCategory?> getFinancialCategoryById(String id);
  Future<List<FinancialCategory>> getFinancialCategories();
  Future<Unit> insertFinancialCategory(FinancialCategory financialCategory);
  Future<Unit> updateFinancialCategory(FinancialCategory financialCategory);
}

class FinancialCategoryDbApiImpl implements FinancialCategoryDbApi {
  FinancialCategoryDbApiImpl(this.financialCategoryDb);
  final FinancialCategoryDb financialCategoryDb;

  @override
  Future<Unit> deleteFinancialCategory(String id) async {
    try {
      await financialCategoryDb.database;
      await financialCategoryDb.deleteFinancialCategory(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<FinancialCategory>> getFinancialCategories() async {
    try {
      await financialCategoryDb.database;
      final result = await financialCategoryDb.getFinancialCategories();

      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<FinancialCategory?> getFinancialCategoryById(String id) async {
    try {
      await financialCategoryDb.database;
      final result = await financialCategoryDb.getFinancialCategory(id);

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
  Future<Unit> insertFinancialCategory(
    FinancialCategory financialCategory,
  ) async {
    try {
      await financialCategoryDb.database;
      await financialCategoryDb.insertFinancialCategory(financialCategory);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateFinancialCategory(
    FinancialCategory financialCategory,
  ) async {
    try {
      await financialCategoryDb.database;
      await financialCategoryDb.updateFinancialCategory(financialCategory);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
