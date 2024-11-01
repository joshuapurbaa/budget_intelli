import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:fpdart/fpdart.dart';

class GetUserFirestoreUsecase implements UseCase<UserIntelli, NoParams> {
  GetUserFirestoreUsecase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserIntelli>> call(NoParams params) {
    return repository.getUserFirestore();
  }
}
