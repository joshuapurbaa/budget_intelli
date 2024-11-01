import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetMyPortfolioByIdDb implements UseCase<MyPortfolioModel?, String> {
  GetMyPortfolioByIdDb(this.repository);
  final MyPortfolioRepository repository;

  @override
  Future<Either<Failure, MyPortfolioModel?>> call(String params) async {
    return repository.getMyPortfolioById(params);
  }
}
