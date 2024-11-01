import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetFinancialCategoryDb implements UseCase<FinancialCategory?, String> {
  GetFinancialCategoryDb(this.repository);
  final FinancialCategoryRepository repository;

  @override
  Future<Either<Failure, FinancialCategory?>> call(String id) {
    return repository.getFinancialCategoryById(id);
  }
}
