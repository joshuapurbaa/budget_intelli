import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetAccountHistoriesUsecase
    implements UseCase<List<AccountHistory>, NoParams> {
  GetAccountHistoriesUsecase(this.repository);

  final AccountHistoryRepository repository;
  @override
  Future<Either<Failure, List<AccountHistory>>> call(NoParams params) {
    return repository.getAccountHistories();
  }
}
