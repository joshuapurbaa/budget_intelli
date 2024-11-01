import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class MyPortfolioRepository {
  Future<Either<Failure, List<MyPortfolioModel>>> getMyPortfolioList();
  Future<Either<Failure, MyPortfolioModel?>> getMyPortfolioById(String id);
  Future<Either<Failure, Unit>> insertMyPortfolio(MyPortfolioModel myPortfolio);
  Future<Either<Failure, Unit>> updateMyPortfolio(MyPortfolioModel myPortfolio);
  Future<Either<Failure, Unit>> deleteMyPortfolio(String id);
}

class MyPortfolioRepositoryImpl implements MyPortfolioRepository {
  MyPortfolioRepositoryImpl(this.api);
  final MyPortfolioDatabaseApi api;

  @override
  Future<Either<Failure, Unit>> deleteMyPortfolio(String id) async {
    try {
      await api.deleteMyPortfolioById(id);
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, MyPortfolioModel?>> getMyPortfolioById(
    String id,
  ) async {
    try {
      final result = await api.getMyPortfolioById(id);
      return right(result);
    } catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MyPortfolioModel>>> getMyPortfolioList() async {
    try {
      final result = await api.getMyPortfolioList();
      return right(result);
    } catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> insertMyPortfolio(
    MyPortfolioModel myPortfolio,
  ) async {
    try {
      await api.insertMyPortfolio(myPortfolio);
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMyPortfolio(
    MyPortfolioModel myPortfolio,
  ) async {
    try {
      await api.updateMyPortfolio(myPortfolio);
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure('DB Failure: $e'));
    }
  }
}
