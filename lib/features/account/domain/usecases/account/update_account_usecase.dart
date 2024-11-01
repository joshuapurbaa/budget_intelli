import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateAccountUsecase implements UseCase<Unit, Account> {
  UpdateAccountUsecase(this.accountRepository);
  final AccountRepository accountRepository;

  @override
  Future<Either<Failure, Unit>> call(Account account) {
    return accountRepository.updateAccount(account);
  }
}
