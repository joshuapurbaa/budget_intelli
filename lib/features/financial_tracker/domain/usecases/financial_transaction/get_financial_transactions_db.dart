import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetAllFinancialTransactionDb
    implements UseCase<List<FinancialTransaction>, NoParams> {
  GetAllFinancialTransactionDb(this.repository);
  final FinancialTransactionRepository repository;

  @override
  Future<Either<Failure, List<FinancialTransaction>>> call(
    NoParams params,
  ) async {
    return repository.getAllFinancialTransaction();
  }
}
