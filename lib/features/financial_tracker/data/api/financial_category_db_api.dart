import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class FinancialCategoryDbApi {
  Future<Unit> deleteFinancialCategory(String id);
  Future<FinancialCategory?> getFinancialCategory(String id);
  Future<List<FinancialCategory>> getAllFinancialCategory();
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
  Future<List<FinancialCategory>> getAllFinancialCategory() async {
    try {
      await financialCategoryDb.database;
      final result = await financialCategoryDb.getAllFinancialCategory();

      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<FinancialCategory?> getFinancialCategory(String id) async {
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
    FinancialCategory param,
  ) async {
    try {
      await financialCategoryDb.database;
      await financialCategoryDb.insertFinancialCategory(param);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateFinancialCategory(
    FinancialCategory param,
  ) async {
    try {
      await financialCategoryDb.database;
      await financialCategoryDb.updateFinancialCategory(param);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
