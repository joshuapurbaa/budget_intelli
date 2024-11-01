import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class FinancialCategoryHistoryRepository {
  Future<Either<Failure, Unit>> deleteFinancialCategoryHistory(String id);
  Future<Either<Failure, FinancialCategoryHistory?>>
      getFinancialCategoryHistoryById(String id);
  Future<Either<Failure, List<FinancialCategoryHistory>>>
      getFinancialCategoryHistories();
  Future<Either<Failure, Unit>> insertFinancialCategoryHistory(
    FinancialCategoryHistory financialCategoryHistory,
  );
  Future<Either<Failure, Unit>> updateFinancialCategoryHistory(
    FinancialCategoryHistory financialCategoryHistory,
  );
}

class FinancialCategoryHistoryRepositoryImpl
    implements FinancialCategoryHistoryRepository {
  FinancialCategoryHistoryRepositoryImpl(this.api);

  final FinancialCategoryHistoryDbApi api;

  @override
  Future<Either<Failure, Unit>> deleteFinancialCategoryHistory(
    String id,
  ) async {
    try {
      await api.deleteFinancialCategoryHistory(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FinancialCategoryHistory>>>
      getFinancialCategoryHistories() async {
    try {
      final result = await api.getFinancialCategoryHistories();
      return right(result);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, FinancialCategoryHistory?>>
      getFinancialCategoryHistoryById(String id) async {
    try {
      final result = await api.getFinancialCategoryHistoryById(id);

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
  Future<Either<Failure, Unit>> insertFinancialCategoryHistory(
    FinancialCategoryHistory financialCategoryHistory,
  ) async {
    try {
      await api.insertFinancialCategoryHistory(financialCategoryHistory);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateFinancialCategoryHistory(
    FinancialCategoryHistory financialCategoryHistory,
  ) async {
    try {
      await api.updateFinancialCategoryHistory(financialCategoryHistory);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }
}
