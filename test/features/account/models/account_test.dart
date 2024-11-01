import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Account', () {
    test('fromMap creates an Account from a map', () {
      final map = {
        'id': '123',
        'name': 'Test Account',
        'account_type': 'Savings',
        'amount': 1000,
        'created_at': '2024-01-01',
        'updated_at': '2024-01-02',
        'icon_path': 'path/to/icon.png',
        'hex_color': '#FFFFFF',
      };

      final account = Account.fromMap(map);

      expect(account.id, '123');
      expect(account.name, 'Test Account');
      expect(account.accountType, 'Savings');
      expect(account.amount, 1000);
      expect(account.createdAt, '2024-01-01');
      expect(account.updatedAt, '2024-01-02');
      expect(account.iconPath, 'path/to/icon.png');
      expect(account.hexColor, '#FFFFFF');
    });

    test('toMap converts an Account to a map', () {
      final account = Account(
        id: '123',
        name: 'Test Account',
        accountType: 'Savings',
        amount: 1000,
        createdAt: '2024-01-01',
        updatedAt: '2024-01-02',
        iconPath: 'path/to/icon.png',
        hexColor: '#FFFFFF',
      );

      final map = account.toMap();

      expect(map['id'], '123');
      expect(map['name'], 'Test Account');
      expect(map['account_type'], 'Savings');
      expect(map['amount'], 1000);
      expect(map['created_at'], '2024-01-01');
      expect(map['updated_at'], '2024-01-02');
      expect(map['icon_path'], 'path/to/icon.png');
      expect(map['hex_color'], '#FFFFFF');
    });

    test('copyWith creates a copy with the desired modifications', () {
      final account = Account(
        id: '123',
        name: 'Test Account',
        accountType: 'Savings',
        amount: 1000,
        createdAt: '2024-01-01',
        updatedAt: '2024-01-02',
        iconPath: 'path/to/icon.png',
        hexColor: '#FFFFFF',
      );

      final modifiedAccount = account.copyWith(
        name: 'Modified Account',
        amount: 2000,
      );

      expect(modifiedAccount.id, '123');
      expect(modifiedAccount.name, 'Modified Account');
      expect(modifiedAccount.accountType, 'Savings');
      expect(modifiedAccount.amount, 2000);
      expect(modifiedAccount.createdAt, '2024-01-01');
      expect(modifiedAccount.updatedAt, '2024-01-02');
      expect(modifiedAccount.iconPath, 'path/to/icon.png');
      expect(modifiedAccount.hexColor, '#FFFFFF');
    });
  });
}
