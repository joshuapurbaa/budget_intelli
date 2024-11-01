import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class InsertAccountUsecase implements UseCase<Unit, Account> {
  InsertAccountUsecase(this.repository);
  final AccountRepository repository;

  @override
  Future<Either<Failure, Unit>> call(Account params) {
    return repository.insertAccount(params);
  }
}
