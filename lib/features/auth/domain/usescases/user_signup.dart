import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for signing up a user.
class UserSignUpUsecase implements UseCase<UserIntelli, UserSignUpParams> {
  UserSignUpUsecase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserIntelli>> call(UserSignUpParams params) async {
    return repository.signUpWithEmailAndPassword(params);
  }
}

/// Parameters for user sign up.
class UserSignUpParams {
  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;
}
