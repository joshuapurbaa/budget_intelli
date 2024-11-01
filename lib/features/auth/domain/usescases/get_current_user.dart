import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentUserSessionUsecase implements UseCase<UserIntelli, NoParams> {
  GetCurrentUserSessionUsecase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserIntelli>> call(NoParams params) async {
    return repository.getCurrentUserSession();
  }
}
