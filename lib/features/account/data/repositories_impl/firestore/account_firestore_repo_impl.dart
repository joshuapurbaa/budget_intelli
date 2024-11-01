import 'package:budget_intelli/core/core.dart';

import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class AccountFirestoreRepoImpl implements AccountFirestoreRepo {
  AccountFirestoreRepoImpl(this._accountFirestoreApi);

  final AccountFirestoreApi _accountFirestoreApi;

  @override
  Future<Either<Failure, Unit>> deleteAccountFire(String id) async {
    try {
      await _accountFirestoreApi.deleteAccountFire(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        FirebaseFailure('Firebase failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Account?>> getAccountByIdFire(String id) async {
    try {
      final result = await _accountFirestoreApi.getAccountByIdFire(id);
      return right(result);
    } on CustomException catch (e) {
      return left(
        FirebaseFailure('Firebase failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Account>>> getAllAccountsFire() async {
    try {
      final result = await _accountFirestoreApi.getAccountsFire();
      return right(result);
    } on CustomException catch (e) {
      return left(
        FirebaseFailure('Firebase failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertAccountFire(Account account) async {
    try {
      await _accountFirestoreApi.insertAccountFire(account);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        FirebaseFailure('Firebase failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAccountFire(Account account) async {
    try {
      await _accountFirestoreApi.updateAccountFire(account);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        FirebaseFailure('Firebase failure: ${e.message}'),
      );
    }
  }
}
