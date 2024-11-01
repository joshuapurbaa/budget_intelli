import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AccountRepository {
  Future<Either<Failure, Unit>> insertAccount(Account account);
  Future<Either<Failure, Unit>> updateAccount(Account account);
  Future<Either<Failure, Unit>> deleteAccount(String id);
  Future<Either<Failure, List<Account>>> getAllAccounts();
  Future<Either<Failure, Account?>> getAccountById(String id);
}
