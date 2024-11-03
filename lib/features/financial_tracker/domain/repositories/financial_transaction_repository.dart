import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class FinancialTransactionRepository {
  Future<Either<Failure, Unit>> deleteFinancialTransaction(String id);
  Future<Either<Failure, FinancialTransaction?>> getFinancialTransaction(
    String id,
  );
  Future<Either<Failure, List<FinancialTransaction>>>
      getAllFinancialTransaction();
  Future<Either<Failure, List<FinancialTransaction>>>
      getAllFinancialTransactionByMonthAndYear(String month, String year);
  Future<Either<Failure, Unit>> insertFinancialTransaction(
    FinancialTransaction param,
  );
  Future<Either<Failure, Unit>> updateFinancialTransaction(
    FinancialTransaction param,
  );
}

class FinancialTransactionRepositoryImpl
    implements FinancialTransactionRepository {
  FinancialTransactionRepositoryImpl(this.api);

  final FinancialTransactionDbApi api;

  @override
  Future<Either<Failure, Unit>> deleteFinancialTransaction(String id) async {
    try {
      await api.deleteFinancialTransaction(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FinancialTransaction>>>
      getAllFinancialTransaction() async {
    try {
      final result = await api.getAllFinancialTransaction();
      return right(result);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, FinancialTransaction?>> getFinancialTransaction(
    String id,
  ) async {
    try {
      final result = await api.getFinancialTransaction(id);

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
  Future<Either<Failure, Unit>> insertFinancialTransaction(
    FinancialTransaction param,
  ) async {
    try {
      await api.insertFinancialTransaction(param);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateFinancialTransaction(
    FinancialTransaction param,
  ) async {
    try {
      await api.updateFinancialTransaction(param);
      return right(unit);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, List<FinancialTransaction>>>
      getAllFinancialTransactionByMonthAndYear(
    String month,
    String year,
  ) async {
    try {
      final result =
          await api.getAllFinancialTransactionByMonthAndYear(month, year);
      return right(result);
    } on CustomException catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }
}
