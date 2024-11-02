import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetFinancialTransactionByIdDb
    implements UseCase<FinancialTransaction?, String> {
  GetFinancialTransactionByIdDb(this.repository);
  final FinancialTransactionRepository repository;

  @override
  Future<Either<Failure, FinancialTransaction?>> call(String id) async {
    return repository.getFinancialTransaction(id);
  }
}
