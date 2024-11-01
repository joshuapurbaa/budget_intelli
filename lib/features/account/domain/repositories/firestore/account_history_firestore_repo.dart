import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AccountHistoryFirestoreRepo {
  Future<Either<Failure, Unit>> insertAccountHistoryFire(
    AccountHistory accountHistory,
  );
  Future<Either<Failure, Unit>> deleteAccountHistoryFire(
    String accountHistory,
  );
  Future<Either<Failure, Unit>> updateAccountHistoryFire(
    AccountHistory accountHistory,
  );
  Future<Either<Failure, List<AccountHistory>>> getAccountHistoriesFire();
  Future<Either<Failure, AccountHistory?>> getAccountHistoryByIdFire(
    String id,
  );
}
