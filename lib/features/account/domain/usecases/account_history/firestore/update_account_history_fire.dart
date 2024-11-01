import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateAccountHistoryFire implements UseCase<Unit, AccountHistory> {
  UpdateAccountHistoryFire(this.accountHistoryRepo);
  final AccountHistoryFirestoreRepo accountHistoryRepo;

  @override
  Future<Either<Failure, Unit>> call(AccountHistory params) {
    return accountHistoryRepo.updateAccountHistoryFire(params);
  }
}
