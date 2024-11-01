import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AccountDatabaseApi {
  Future<Account?> getAccountById(String id);
  Future<List<Account>> getAccounts();
  Future<Unit> insertAccount(Account account);
  Future<Unit> deleteAccount(String id);
  Future<Unit> updateAccount(Account account);
}

class AccountDatabaseApiImpl implements AccountDatabaseApi {
  AccountDatabaseApiImpl(this.accountDatabase);
  final AccountDatabase accountDatabase;

  @override
  Future<Unit> deleteAccount(String id) async {
    try {
      await accountDatabase.database;
      await accountDatabase.deleteAccount(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Account?> getAccountById(String id) async {
    try {
      await accountDatabase.database;
      final result = await accountDatabase.getAccount(id);

      if (result != null) {
        return result;
      } else {
        return null;
      }
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<Account>> getAccounts() async {
    try {
      await accountDatabase.database;
      final result = await accountDatabase.getAllAccounts();

      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertAccount(Account account) async {
    try {
      await accountDatabase.database;
      await accountDatabase.insertAccount(account);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateAccount(Account account) async {
    try {
      await accountDatabase.database;
      await accountDatabase.updateAccount(account);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
