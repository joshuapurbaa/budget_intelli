import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateAccountFirestore implements UseCase<Unit, Account> {
  UpdateAccountFirestore(this.accountFirestoreRepo);
  final AccountFirestoreRepo accountFirestoreRepo;

  @override
  Future<Either<Failure, Unit>> call(Account params) {
    return accountFirestoreRepo.updateAccountFire(params);
  }
}
