import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetAccountsUsecase implements UseCase<List<Account>, NoParams> {
  GetAccountsUsecase(this.repository);
  final AccountRepository repository;

  @override
  Future<Either<Failure, List<Account>>> call(NoParams params) {
    return repository.getAllAccounts();
  }
}
