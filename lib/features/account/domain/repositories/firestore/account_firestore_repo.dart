import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AccountFirestoreRepo {
  Future<Either<Failure, Unit>> insertAccountFire(Account account);
  Future<Either<Failure, Unit>> updateAccountFire(Account account);
  Future<Either<Failure, Unit>> deleteAccountFire(String id);
  Future<Either<Failure, List<Account>>> getAllAccountsFire();
  Future<Either<Failure, Account?>> getAccountByIdFire(String id);
}
