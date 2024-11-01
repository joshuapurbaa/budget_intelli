import 'package:budget_intelli/core/error/failures.dart';
import 'package:budget_intelli/core/utils/usecase.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertAccountHistoryUsecase implements UseCase<Unit, AccountHistory> {
  InsertAccountHistoryUsecase(this.repository);
  final AccountHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(AccountHistory params) {
    return repository.insertAccountHistory(params);
  }
}
