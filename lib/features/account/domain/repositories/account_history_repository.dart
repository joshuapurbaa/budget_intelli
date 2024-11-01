import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AccountHistoryRepository {
  Future<Either<Failure, Unit>> insertAccountHistory(
    AccountHistory accountHistory,
  );
  Future<Either<Failure, Unit>> deleteAccountHistory(
    String accountHistory,
  );
  Future<Either<Failure, Unit>> updateAccountHistory(
    AccountHistory accountHistory,
  );
  Future<Either<Failure, List<AccountHistory>>> getAccountHistories();
  Future<Either<Failure, AccountHistory?>> getAccountHistoryById(
    String id,
  );
}
