import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/domain/domain.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertFinancialCategoryDb implements UseCase<Unit, FinancialCategory> {
  InsertFinancialCategoryDb(this.repository);
  final FinancialCategoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(FinancialCategory params) async {
    return repository.insertFinancialCategory(params);
  }
}
