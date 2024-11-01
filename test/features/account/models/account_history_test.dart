import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountHistory', () {
    test('fromMap creates an AccountHistory from a map', () {
      final map = {
        'id': '123',
        'account_id': 'acc_456',
        'name': 'Test Account History',
        'amount': 500,
        'created_at': '2024-01-01',
        'updated_at': '2024-01-02',
        'icon_path': 'path/to/icon.png',
        'hex_color': 0xFFFFFF,
      };

      final accountHistory = AccountHistory.fromMap(map);

      expect(accountHistory.id, '123');
      expect(accountHistory.accountId, 'acc_456');
      expect(accountHistory.name, 'Test Account History');
      expect(accountHistory.amount, 500);
      expect(accountHistory.createdAt, '2024-01-01');
      expect(accountHistory.updatedAt, '2024-01-02');
      expect(accountHistory.iconPath, 'path/to/icon.png');
      expect(accountHistory.hexColor, 0xFFFFFF);
    });

    test('toMap converts an AccountHistory to a map', () {
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

      final map = accountHistory.toMap();

      expect(map['id'], '123');
      expect(map['account_id'], 'acc_456');
      expect(map['name'], 'Test Account History');
      expect(map['amount'], 500);
      expect(map['created_at'], '2024-01-01');
      expect(map['updated_at'], '2024-01-02');
      expect(map['icon_path'], 'path/to/icon.png');
      expect(map['hex_color'], 0xFFFFFF);
    });

    test('copyWith creates a copy with the desired modifications', () {
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

      final modifiedAccountHistory = accountHistory.copyWith(
        name: 'Modified Account History',
        amount: 1000,
      );

      expect(modifiedAccountHistory.id, '123');
      expect(modifiedAccountHistory.accountId, 'acc_456');
      expect(modifiedAccountHistory.name, 'Modified Account History');
      expect(modifiedAccountHistory.amount, 1000);
      expect(modifiedAccountHistory.createdAt, '2024-01-01');
      expect(modifiedAccountHistory.updatedAt, '2024-01-02');
      expect(modifiedAccountHistory.iconPath, 'path/to/icon.png');
      expect(modifiedAccountHistory.hexColor, 0xFFFFFF);
    });
  });
}
