import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/domain/domain.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAccountHistoryUsecase implements UseCase<Unit, String> {
  DeleteAccountHistoryUsecase(this.repository);
  final AccountHistoryRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String params) {
    return repository.deleteAccountHistory(params);
  }
}
