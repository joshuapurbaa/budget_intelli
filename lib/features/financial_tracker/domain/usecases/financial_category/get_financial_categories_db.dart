import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/domain/domain.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetFinancialCategoriesDb
    implements UseCase<List<FinancialCategory>, NoParams> {
  GetFinancialCategoriesDb(this.repository);
  final FinancialCategoryRepository repository;

  @override
  Future<Either<Failure, List<FinancialCategory>>> call(NoParams params) {
    return repository.getFinancialCategories();
  }
}
