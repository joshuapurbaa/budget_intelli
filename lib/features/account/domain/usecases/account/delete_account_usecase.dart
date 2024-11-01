import 'package:budget_intelli/core/error/failures.dart';
import 'package:budget_intelli/core/utils/usecase.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAccountUsecase implements UseCase<Unit, String> {
  DeleteAccountUsecase(this.repository);
  final AccountRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String params) {
    return repository.deleteAccount(params);
  }
}
