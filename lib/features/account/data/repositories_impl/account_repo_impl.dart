import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class AccountRepoImpl implements AccountRepository {
  AccountRepoImpl({required this.accountDatabaseApi});
  final AccountDatabaseApi accountDatabaseApi;

  @override
  Future<Either<Failure, Unit>> deleteAccount(String id) async {
    try {
      await accountDatabaseApi.deleteAccount(id);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Account?>> getAccountById(String id) async {
    try {
      final account = await accountDatabaseApi.getAccountById(id);
      return right(account);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Account>>> getAllAccounts() async {
    try {
      final accounts = await accountDatabaseApi.getAccounts();
      return right(accounts);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> insertAccount(Account account) async {
    try {
      await accountDatabaseApi.insertAccount(account);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAccount(Account account) async {
    try {
      await accountDatabaseApi.updateAccount(account);
      return right(unit);
    } on CustomException catch (e) {
      return left(
        DatabaseFailure('Db failure: ${e.message}'),
      );
    }
  }
}
