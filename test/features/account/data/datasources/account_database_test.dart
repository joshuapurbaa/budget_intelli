import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  // Override the openDatabase factory to use ffi
  databaseFactory = databaseFactoryFfi;

  late AccountDatabase accountDatabase;

  setUp(() async {
    accountDatabase = AccountDatabase();
    await accountDatabase.initDatabase();
  });

  tearDown(() async {
    await accountDatabase.close();
  });

  test('Insert and retrieve an account', () async {
    final account = Account(
      id: '1',
      name: 'Test Account',
      accountType: 'Savings',
      amount: 1000,
      createdAt: '2023-01-01',
      updatedAt: '2023-01-01',
      iconPath: 'path/to/icon',
      hexColor: '0xFFFFFF',
    );

    await accountDatabase.insertAccount(account);
    final retrievedAccount = await accountDatabase.getAccount('1');

    expect(retrievedAccount, isNotNull);
    expect(retrievedAccount!.id, account.id);
    expect(retrievedAccount.name, account.name);
    expect(retrievedAccount.accountType, account.accountType);
    expect(retrievedAccount.amount, account.amount);
  });

  test('Update an account', () async {
    final account = Account(
      id: '1',
      name: 'Test Account',
      accountType: 'Savings',
      amount: 1000,
      createdAt: '2023-01-01',
      updatedAt: '2023-01-01',
      iconPath: 'path/to/icon',
      hexColor: '0xFFFFFF',
    );

    await accountDatabase.insertAccount(account);

    final updatedAccount = Account(
      id: '1',
      name: 'Updated Account',
      accountType: 'Savings',
      amount: 2000,
      createdAt: '2023-01-01',
      updatedAt: '2023-01-02',
      iconPath: 'path/to/icon',
      hexColor: '0xFFFFFF',
    );

    await accountDatabase.updateAccount(updatedAccount);
    final retrievedAccount = await accountDatabase.getAccount('1');

    expect(retrievedAccount, isNotNull);
    expect(retrievedAccount!.name, updatedAccount.name);
    expect(retrievedAccount.amount, updatedAccount.amount);
  });

  test('Delete an account', () async {
    final account = Account(
      id: '1',
      name: 'Test Account',
      accountType: 'Savings',
      amount: 1000,
      createdAt: '2023-01-01',
      updatedAt: '2023-01-01',
      iconPath: 'path/to/icon',
      hexColor: '0xFFFFFF',
    );

    await accountDatabase.insertAccount(account);
    await accountDatabase.deleteAccount('1');
    final retrievedAccount = await accountDatabase.getAccount('1');

    expect(retrievedAccount, isNull);
  });

  test('Retrieve all accounts', () async {
    final account1 = Account(
      id: '1',
      name: 'Test Account 1',
      accountType: 'Savings',
      amount: 1000,
      createdAt: '2023-01-01',
      updatedAt: '2023-01-01',
      iconPath: 'path/to/icon',
      hexColor: '0xFFFFFF',
    );

    final account2 = Account(
      id: '2',
      name: 'Test Account 2',
      accountType: 'Checking',
      amount: 2000,
      createdAt: '2023-01-02',
      updatedAt: '2023-01-02',
      iconPath: 'path/to/icon',
      hexColor: '0xFFFFFF',
    );

    await accountDatabase.insertAccount(account1);
    await accountDatabase.insertAccount(account2);

    final accounts = await accountDatabase.getAllAccounts();

    expect(accounts.length, 2);
    expect(accounts[0].name, account1.name);
    expect(accounts[1].name, account2.name);
  });

  // Similar tests can be written for AccountHistory
  group(
    'Account History',
    () {
      test(
        'Insert and retrieve an account history',
        () async {
          final accountHistory = AccountHistory(
            id: '123',
            accountId: 'acc_456',
            name: 'Test Account History',
            amount: 500,
            createdAt: '2024-01-01',
            updatedAt: '2024-01-02',
            iconPath: 'path/to/icon.png',
            hexColor: 0xFFFFFF,
          );

          await accountDatabase.insertAccountHistory(accountHistory);
          final retrievedAccountHistory =
              await accountDatabase.getAccountHistory('123');

          expect(retrievedAccountHistory, isNotNull);
          expect(retrievedAccountHistory!.id, accountHistory.id);
          expect(retrievedAccountHistory.accountId, accountHistory.accountId);
          expect(retrievedAccountHistory.name, accountHistory.name);
          expect(retrievedAccountHistory.amount, accountHistory.amount);
        },
      );

      test(
        'Update an account history',
        () async {
          final accountHistory = AccountHistory(
            id: '123',
            accountId: 'acc_456',
            name: 'Test Account History',
            amount: 500,
            createdAt: '2024-01-01',
            updatedAt: '2024-01-02',
            iconPath: 'path/to/icon.png',
            hexColor: 0xFFFFFF,
          );

          await accountDatabase.insertAccountHistory(accountHistory);

          final updatedAccountHistory = AccountHistory(
            id: '123',
            accountId: 'acc_456',
            name: 'Updated Account History',
            amount: 1000,
            createdAt: '2024-01-01',
            updatedAt: '2024-01-02',
            iconPath: 'path/to/icon.png',
            hexColor: 0xFFFFFF,
          );

          await accountDatabase.updateAccountHistory(updatedAccountHistory);
          final retrievedAccountHistory =
              await accountDatabase.getAccountHistory('123');

          expect(retrievedAccountHistory, isNotNull);
          expect(retrievedAccountHistory!.name, updatedAccountHistory.name);
          expect(retrievedAccountHistory.amount, updatedAccountHistory.amount);
        },
      );

      test(
        'Delete an account history',
        () async {
          final accountHistory = AccountHistory(
            id: '123',
            accountId: 'acc_456',
            name: 'Test Account History',
            amount: 500,
            createdAt: '2024-01-01',
            updatedAt: '2024-01-02',
            iconPath: 'path/to/icon.png',
            hexColor: 0xFFFFFF,
          );

          await accountDatabase.insertAccountHistory(accountHistory);
          await accountDatabase.deleteAccountHistory('123');
          final retrievedAccountHistory =
              await accountDatabase.getAccountHistory('123');

          expect(retrievedAccountHistory, isNull);
        },
      );

      test(
        'Retrieve all account histories',
        () async {
          final accountHistory1 = AccountHistory(
            id: '123',
            accountId: 'acc_456',
            name: 'Test Account History 1',
            amount: 500,
            createdAt: '2024-01-01',
            updatedAt: '2024-01-02',
            iconPath: 'path/to/icon.png',
            hexColor: 0xFFFFFF,
          );

          final accountHistory2 = AccountHistory(
            id: '456',
            accountId: 'acc_789',
            name: 'Test Account History 2',
            amount: 1000,
            createdAt: '2024-01-02',
            updatedAt: '2024-01-03',
            iconPath: 'path/to/icon.png',
            hexColor: 0xFFFFFF,
          );

          await accountDatabase.insertAccountHistory(accountHistory1);
          await accountDatabase.insertAccountHistory(accountHistory2);

          final accountHistories =
              await accountDatabase.getAllAccountHistories();

          expect(accountHistories.length, 2);
          expect(accountHistories[0].name, accountHistory1.name);
          expect(accountHistories[1].name, accountHistory2.name);
        },
      );

      test('Get account history by id', () async {
        final accountHistory = AccountHistory(
          id: '123',
          accountId: 'acc_456',
          name: 'Test Account History',
          amount: 500,
          createdAt: '2024-01-01',
          updatedAt: '2024-01-02',
          iconPath: 'path/to/icon.png',
          hexColor: 0xFFFFFF,
        );

        await accountDatabase.insertAccountHistory(accountHistory);
        final retrievedAccountHistory =
            await accountDatabase.getAccountHistory('123');

        expect(retrievedAccountHistory, isNotNull);
        expect(retrievedAccountHistory!.id, accountHistory.id);
        expect(retrievedAccountHistory.accountId, accountHistory.accountId);
        expect(retrievedAccountHistory.name, accountHistory.name);
        expect(retrievedAccountHistory.amount, accountHistory.amount);
      });
    },
  );
}
