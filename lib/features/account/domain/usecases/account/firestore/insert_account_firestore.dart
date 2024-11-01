import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertAccountFirestore implements UseCase<Unit, Account> {
  InsertAccountFirestore(this.accountFirestoreRepo);

  final AccountFirestoreRepo accountFirestoreRepo;

  @override
  Future<Either<Failure, Unit>> call(Account params) {
    return accountFirestoreRepo.insertAccountFire(params);
  }
}
