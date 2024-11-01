import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class AccountHistoryRepoImpl implements AccountHistoryRepository {
  AccountHistoryRepoImpl(this.databaseApi);

  final AccountHistoryDatabaseApi databaseApi;
  @override
  Future<Either<Failure, Unit>> deleteAccountHistory(String id) async {
    try {
      await databaseApi.deleteAccountHistory(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<AccountHistory>>> getAccountHistories() async {
    try {
      final result = await databaseApi.getAccountHistories();
      return right(result);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, AccountHistory?>> getAccountHistoryById(
    String id,
  ) async {
    try {
      final result = await databaseApi.getAccountHistoryById(id);
      return right(result);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertAccountHistory(
    AccountHistory accountHistory,
  ) async {
    try {
      await databaseApi.insertAccountHistory(accountHistory);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAccountHistory(
    AccountHistory accountHistory,
  ) async {
    try {
      await databaseApi.updateAccountHistory(accountHistory);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }
}
