import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyPortfolioModel', () {
    test('fromMap creates a valid instance', () {
      final map = {
        'id': '1',
        'stock_symbol': 'AAPL',
        'company_name': 'Apple Inc.',
        'buy_price': 150.0,
        'lot': 10,
        'stop_loss': 140.0,
        'take_profit': 160.0,
        'buy_date': '2023-10-01',
        'created_at': '2023-10-01',
        'updated_at': '2023-10-01',
      };

      final model = MyPortfolioModel.fromMap(map);

      expect(model.id, '1');
      expect(model.stockSymbol, 'AAPL');
      expect(model.companyName, 'Apple Inc.');
      expect(model.buyPrice, 150.0);
      expect(model.lot, 10);
      expect(model.stopLoss, 140.0);
      expect(model.takeProfit, 160.0);
      expect(model.buyDate, '2023-10-01');
      expect(model.createdAt, '2023-10-01');
      expect(model.updatedAt, '2023-10-01');
    });

    test('toMap returns a valid map', () {
      final model = MyPortfolioModel(
        id: '1',
        stockSymbol: 'AAPL',
        companyName: 'Apple Inc.',
        buyPrice: 150,
        lot: 10,
        stopLoss: 140,
        takeProfit: 160,
        buyDate: '2023-10-01',
        createdAt: '2023-10-01',
        updatedAt: '2023-10-01',
        buyReason: 'I like the company',
        closePrice: 155,
      );

      final map = model.toMap();

      expect(map['id'], '1');
      expect(map['stock_symbol'], 'AAPL');
      expect(map['company_name'], 'Apple Inc.');
      expect(map['buy_price'], 150.0);
      expect(map['lot'], 10);
      expect(map['stop_loss'], 140.0);
      expect(map['take_profit'], 160.0);
      expect(map['buy_date'], '2023-10-01');
      expect(map['created_at'], '2023-10-01');
      expect(map['updated_at'], '2023-10-01');
    });

    test('fromMap handles null takeProfit', () {
      final map = {
        'id': '1',
        'stock_symbol': 'AAPL',
        'company_name': 'Apple Inc.',
        'buy_price': 150.0,
        'lot': 10,
        'stop_loss': 140.0,
        'take_profit': null,
        'buy_date': '2023-10-01',
        'created_at': '2023-10-01',
        'updated_at': '2023-10-01',
      };

      final model = MyPortfolioModel.fromMap(map);

      expect(model.takeProfit, null);
    });
  });
}
