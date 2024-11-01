import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateAccountHistoryUsecase implements UseCase<Unit, AccountHistory> {
  UpdateAccountHistoryUsecase(this.repository);

  final AccountHistoryRepository repository;
  @override
  Future<Either<Failure, Unit>> call(AccountHistory params) {
    return repository.updateAccountHistory(params);
  }
}
