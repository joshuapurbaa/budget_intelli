import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetFinancialCategoryHistoriesDb
    implements UseCase<List<FinancialCategoryHistory>, NoParams> {
  GetFinancialCategoryHistoriesDb(this.repository);
  final FinancialCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, List<FinancialCategoryHistory>>> call(
    NoParams params,
  ) {
    return repository.getFinancialCategoryHistories();
  }
}
