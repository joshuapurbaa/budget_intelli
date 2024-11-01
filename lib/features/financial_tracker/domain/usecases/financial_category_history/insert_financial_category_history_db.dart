import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertFinancialCategoryHistoryDb
    implements UseCase<Unit, FinancialCategoryHistory> {
  InsertFinancialCategoryHistoryDb(this.repository);
  final FinancialCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(FinancialCategoryHistory params) {
    return repository.insertFinancialCategoryHistory(params);
  }
}
