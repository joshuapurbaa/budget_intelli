import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class AccountHistoryFirestoreRepoImpl implements AccountHistoryFirestoreRepo {
  AccountHistoryFirestoreRepoImpl(this._accountHistoryFirestoreApi);

  final AccountHistoryFirestoreApi _accountHistoryFirestoreApi;

  @override
  Future<Either<Failure, Unit>> deleteAccountHistoryFire(String id) async {
    try {
      await _accountHistoryFirestoreApi.deleteAccountHistoryFire(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        FirebaseFailure('Firebase failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<AccountHistory>>>
      getAccountHistoriesFire() async {
    try {
      final result =
          await _accountHistoryFirestoreApi.getAccountHistoriesFire();
      return right(result);
    } on CustomException catch (e) {
      return left(
        FirebaseFailure('Firebase failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, AccountHistory?>> getAccountHistoryByIdFire(
    String id,
  ) async {
    try {
      final result =
          await _accountHistoryFirestoreApi.getAccountHistoryFireById(id);
      return right(result);
    } on CustomException catch (e) {
      return left(
        FirebaseFailure('Firebase failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertAccountHistoryFire(
    AccountHistory accountHistory,
  ) async {
    try {
      await _accountHistoryFirestoreApi
          .insertAccountHistoryFire(accountHistory);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        FirebaseFailure('Firebase failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAccountHistoryFire(
    AccountHistory accountHistory,
  ) async {
    try {
      await _accountHistoryFirestoreApi
          .updateAccountHistoryFire(accountHistory);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        FirebaseFailure('Firebase failure: ${e.message}'),
      );
    }
  }
}
