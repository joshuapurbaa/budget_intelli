import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertAccountHistoryFire implements UseCase<Unit, AccountHistory> {
  InsertAccountHistoryFire(this.accountHistory);
  final AccountHistoryFirestoreRepo accountHistory;

  @override
  Future<Either<Failure, Unit>> call(AccountHistory params) {
    return accountHistory.insertAccountHistoryFire(params);
  }
}
