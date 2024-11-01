import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:fpdart/fpdart.dart';

class UpdateUserFirestoreUsecases implements UseCase<UserIntelli, UserIntelli> {
  UpdateUserFirestoreUsecases(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserIntelli>> call(UserIntelli params) async {
    return repository.updateUserFirestore(params);
  }
}
