import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;

  late MyPortfolioDatabase myPortfolioDatabase;

  setUp(() async {
    myPortfolioDatabase = MyPortfolioDatabase();
    await myPortfolioDatabase.initDatabase();
  });

  tearDown(() async {
    await myPortfolioDatabase.close();
  });

  test('insertMyPortfolio inserts a portfolio entry into the database',
      () async {
    final myPortfolio = MyPortfolioModel(
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

    await myPortfolioDatabase.insertMyPortfolio(myPortfolio);

    final db = await myPortfolioDatabase.database;
    final result = await db
        .query('MyPortfolio', where: 'id = ?', whereArgs: [myPortfolio.id]);

    expect(result.length, 1);
    expect(result.first['stock_symbol'], myPortfolio.stockSymbol);
    expect(result.first['company_name'], myPortfolio.companyName);
    expect(result.first['buy_price'], myPortfolio.buyPrice);
    expect(result.first['lot'], myPortfolio.lot);
    expect(result.first['stop_loss'], myPortfolio.stopLoss);
    expect(result.first['take_profit'], myPortfolio.takeProfit);
    expect(result.first['buy_date'], myPortfolio.buyDate);
    expect(result.first['created_at'], myPortfolio.createdAt);
    expect(result.first['updated_at'], myPortfolio.updatedAt);
  });

  test('getMyPortfolioById retrieves a portfolio entry by id', () async {
    final myPortfolio = MyPortfolioModel(
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

    await myPortfolioDatabase.insertMyPortfolio(myPortfolio);

    final retrievedPortfolio =
        await myPortfolioDatabase.getMyPortfolioById('1');

    expect(retrievedPortfolio, isNotNull);
    expect(retrievedPortfolio!.id, myPortfolio.id);
    expect(retrievedPortfolio.stockSymbol, myPortfolio.stockSymbol);
    expect(retrievedPortfolio.companyName, myPortfolio.companyName);
    expect(retrievedPortfolio.buyPrice, myPortfolio.buyPrice);
    expect(retrievedPortfolio.lot, myPortfolio.lot);
    expect(retrievedPortfolio.stopLoss, myPortfolio.stopLoss);
    expect(retrievedPortfolio.takeProfit, myPortfolio.takeProfit);
    expect(retrievedPortfolio.buyDate, myPortfolio.buyDate);
    expect(retrievedPortfolio.createdAt, myPortfolio.createdAt);
    expect(retrievedPortfolio.updatedAt, myPortfolio.updatedAt);
  });

  test('getMyPortfolioList retrieves all portfolio entries', () async {
    final myPortfolio1 = MyPortfolioModel(
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

    final myPortfolio2 = MyPortfolioModel(
      id: '2',
      stockSymbol: 'GOOGL',
      companyName: 'Alphabet Inc.',
      buyPrice: 2800,
      lot: 5,
      stopLoss: 2700,
      takeProfit: 2900,
      buyDate: '2023-10-02',
      createdAt: '2023-10-02',
      updatedAt: '2023-10-02',
      buyReason: 'I like the company',
      closePrice: 2850,
    );

    await myPortfolioDatabase.insertMyPortfolio(myPortfolio1);
    await myPortfolioDatabase.insertMyPortfolio(myPortfolio2);

    final portfolioList = await myPortfolioDatabase.getMyPortfolioList();

    expect(portfolioList.length, 2);
    expect(portfolioList[0].id, myPortfolio2.id);
    expect(portfolioList[0].stockSymbol, myPortfolio2.stockSymbol);
    expect(portfolioList[0].companyName, myPortfolio2.companyName);
    expect(portfolioList[0].buyPrice, myPortfolio2.buyPrice);
    expect(portfolioList[0].lot, myPortfolio2.lot);
    expect(portfolioList[0].stopLoss, myPortfolio2.stopLoss);
    expect(portfolioList[0].takeProfit, myPortfolio2.takeProfit);
    expect(portfolioList[0].buyDate, myPortfolio2.buyDate);
    expect(portfolioList[0].createdAt, myPortfolio2.createdAt);
    expect(portfolioList[0].updatedAt, myPortfolio2.updatedAt);

    expect(portfolioList[1].id, myPortfolio1.id);
    expect(portfolioList[1].stockSymbol, myPortfolio1.stockSymbol);
    expect(portfolioList[1].companyName, myPortfolio1.companyName);
    expect(portfolioList[1].buyPrice, myPortfolio1.buyPrice);
    expect(portfolioList[1].lot, myPortfolio1.lot);
    expect(portfolioList[1].stopLoss, myPortfolio1.stopLoss);
    expect(portfolioList[1].takeProfit, myPortfolio1.takeProfit);
    expect(portfolioList[1].buyDate, myPortfolio1.buyDate);
    expect(portfolioList[1].createdAt, myPortfolio1.createdAt);
    expect(portfolioList[1].updatedAt, myPortfolio1.updatedAt);
  });
}
