import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/domain/domain.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateFinancialCategoryDb implements UseCase<Unit, FinancialCategory> {
  UpdateFinancialCategoryDb(this.repository);
  final FinancialCategoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(FinancialCategory params) async {
    return repository.updateFinancialCategory(params);
  }
}
