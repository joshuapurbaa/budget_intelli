import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetMyPortfolioListDb
    implements UseCase<List<MyPortfolioModel>, NoParams> {
  GetMyPortfolioListDb(this.repository);
  final MyPortfolioRepository repository;

  @override
  Future<Either<Failure, List<MyPortfolioModel>>> call(NoParams params) async {
    return repository.getMyPortfolioList();
  }
}
