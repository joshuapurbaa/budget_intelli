import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/domain/domain.dart';
import 'package:fpdart/fpdart.dart';

class DeleteFinancialCategoryDb implements UseCase<Unit, String> {
  DeleteFinancialCategoryDb(this.repository);
  final FinancialCategoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String params) {
    return repository.deleteFinancialCategory(params);
  }
}
