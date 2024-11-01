import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertMyPortfolioDb implements UseCase<Unit, MyPortfolioModel> {
  InsertMyPortfolioDb(this.repository);
  final MyPortfolioRepository repository;

  @override
  Future<Either<Failure, Unit>> call(MyPortfolioModel params) async {
    return repository.insertMyPortfolio(params);
  }
}
