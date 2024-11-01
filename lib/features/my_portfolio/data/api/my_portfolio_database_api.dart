import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class MyPortfolioDatabaseApi {
  Future<MyPortfolioModel?> getMyPortfolioById(String id);
  Future<List<MyPortfolioModel>> getMyPortfolioList();
  Future<Unit> insertMyPortfolio(MyPortfolioModel portfolio);
  Future<Unit> deleteMyPortfolioById(String id);
  Future<Unit> updateMyPortfolio(MyPortfolioModel portfolio);
}

class MyPortfolioDatabaseApiImpl implements MyPortfolioDatabaseApi {
  MyPortfolioDatabaseApiImpl(this.portfolioDatabase);

  final MyPortfolioDatabase portfolioDatabase;

  @override
  Future<Unit> deleteMyPortfolioById(String id) async {
    try {
      await portfolioDatabase.database;
      await portfolioDatabase.deleteMyPortfolioById(id);
      return unit;
    } catch (e) {
      throw CustomException('$e');
    }
  }

  @override
  Future<MyPortfolioModel?> getMyPortfolioById(String id) async {
    try {
      await portfolioDatabase.database;
      final result = await portfolioDatabase.getMyPortfolioById(id);
      return result;
    } catch (e) {
      throw CustomException('$e');
    }
  }

  @override
  Future<List<MyPortfolioModel>> getMyPortfolioList() async {
    try {
      await portfolioDatabase.database;
      final result = await portfolioDatabase.getMyPortfolioList();
      return result;
    } catch (e) {
      throw CustomException('$e');
    }
  }

  @override
  Future<Unit> insertMyPortfolio(MyPortfolioModel portfolio) async {
    try {
      await portfolioDatabase.database;
      await portfolioDatabase.insertMyPortfolio(portfolio);
      return unit;
    } catch (e) {
      throw CustomException('$e');
    }
  }

  @override
  Future<Unit> updateMyPortfolio(MyPortfolioModel portfolio) async {
    try {
      await portfolioDatabase.database;
      await portfolioDatabase.updateMyPortfolio(portfolio);
      return unit;
    } catch (e) {
      throw CustomException('$e');
    }
  }
}
