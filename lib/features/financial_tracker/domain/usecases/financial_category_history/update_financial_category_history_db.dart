import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/domain/domain.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateFinancialCategoryHistoryDb
    implements UseCase<Unit, FinancialCategoryHistory> {
  UpdateFinancialCategoryHistoryDb(this.repository);
  final FinancialCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(FinancialCategoryHistory params) {
    return repository.updateFinancialCategoryHistory(params);
  }
}
