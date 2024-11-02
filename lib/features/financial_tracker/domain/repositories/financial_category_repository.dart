import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class FinancialCategoryRepository {
  Future<Either<Failure, Unit>> deleteFinancialCategory(String id);
  Future<Either<Failure, FinancialCategory?>> getFinancialCategory(
    String id,
  );
  Future<Either<Failure, List<FinancialCategory>>> getAllFinancialCategory();
  Future<Either<Failure, Unit>> insertFinancialCategory(
    FinancialCategory financialCategory,
  );
  Future<Either<Failure, Unit>> updateFinancialCategory(
    FinancialCategory financialCategory,
  );
}

class FinancialCategoryRepositoryImpl implements FinancialCategoryRepository {
  FinancialCategoryRepositoryImpl(this.api);

  final FinancialCategoryDbApi api;
  @override
  Future<Either<Failure, Unit>> deleteFinancialCategory(String id) async {
    try {
      await api.deleteFinancialCategory(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FinancialCategory>>>
      getAllFinancialCategory() async {
    try {
      final result = await api.getAllFinancialCategory();
      return right(result);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, FinancialCategory?>> getFinancialCategory(
    String id,
  ) async {
    try {
      final result = await api.getFinancialCategory(id);

      if (result != null) {
        return right(result);
      } else {
        return left(DatabaseFailure('DB Failure: No data found'));
      }
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> insertFinancialCategory(
    FinancialCategory financialCategory,
  ) async {
    try {
      await api.insertFinancialCategory(financialCategory);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateFinancialCategory(
    FinancialCategory financialCategory,
  ) async {
    try {
      await api.updateFinancialCategory(financialCategory);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }
}
