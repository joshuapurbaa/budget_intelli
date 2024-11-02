import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteFinancialTransactionDb implements UseCase<Unit, String> {
  DeleteFinancialTransactionDb(this.repository);
  final FinancialTransactionRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return repository.deleteFinancialTransaction(id);
  }
}
