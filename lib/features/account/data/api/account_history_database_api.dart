import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AccountHistoryDatabaseApi {
  Future<AccountHistory?> getAccountHistoryById(String id);
  Future<List<AccountHistory>> getAccountHistories();
  Future<Unit> insertAccountHistory(AccountHistory account);
  Future<Unit> deleteAccountHistory(String id);
  Future<Unit> updateAccountHistory(AccountHistory account);
}

class AccountHistoryDatabaseApiImpl implements AccountHistoryDatabaseApi {
  AccountHistoryDatabaseApiImpl(this.accountDatabase);

  final AccountDatabase accountDatabase;
  @override
  Future<Unit> deleteAccountHistory(String id) async {
    try {
      await accountDatabase.database;
      await accountDatabase.deleteAccountHistory(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<AccountHistory>> getAccountHistories() async {
    try {
      await accountDatabase.database;
      final result = await accountDatabase.getAllAccountHistories();
      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<AccountHistory?> getAccountHistoryById(String id) async {
    try {
      await accountDatabase.database;
      final result = await accountDatabase.getAccountHistory(id);
      return result;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertAccountHistory(AccountHistory accountHistory) async {
    try {
      await accountDatabase.database;
      await accountDatabase.insertAccountHistory(accountHistory);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateAccountHistory(AccountHistory accountHistory) async {
    try {
      await accountDatabase.database;
      await accountDatabase.updateAccountHistory(accountHistory);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
