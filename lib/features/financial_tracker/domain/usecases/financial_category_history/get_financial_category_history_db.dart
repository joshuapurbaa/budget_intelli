import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/domain/domain.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetFinancialCategoryHistoryDb
    implements UseCase<FinancialCategoryHistory?, String> {
  GetFinancialCategoryHistoryDb(this.repository);
  final FinancialCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, FinancialCategoryHistory?>> call(String id) {
    return repository.getFinancialCategoryHistoryById(id);
  }
}
