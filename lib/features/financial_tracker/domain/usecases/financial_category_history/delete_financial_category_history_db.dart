import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/domain/domain.dart';
import 'package:fpdart/fpdart.dart';

class DeleteFinancialCategoryHistoryDb implements UseCase<Unit, String> {
  DeleteFinancialCategoryHistoryDb(this.repository);
  final FinancialCategoryHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String params) {
    return repository.deleteFinancialCategoryHistory(params);
  }
}
