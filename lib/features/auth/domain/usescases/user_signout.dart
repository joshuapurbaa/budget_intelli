import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignOut implements UseCase<Unit, NoParams> {
  UserSignOut(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return repository.signOut();
  }
}
