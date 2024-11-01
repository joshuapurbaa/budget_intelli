import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetAccountByIdUsecase implements UseCase<Account?, String> {
  GetAccountByIdUsecase(this.repository);
  final AccountRepository repository;

  @override
  Future<Either<Failure, Account?>> call(String accountId) {
    return repository.getAccountById(accountId);
  }
}
