import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteMyPortfolioDb implements UseCase<Unit, String> {
  DeleteMyPortfolioDb(this.repository);
  final MyPortfolioRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return repository.deleteMyPortfolio(params);
  }
}
