import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateFinancialTransactionDb
    implements UseCase<Unit, FinancialTransaction> {
  UpdateFinancialTransactionDb(this.repository);
  final FinancialTransactionRepository repository;

  @override
  Future<Either<Failure, Unit>> call(FinancialTransaction params) async {
    return repository.updateFinancialTransaction(params);
  }
}
