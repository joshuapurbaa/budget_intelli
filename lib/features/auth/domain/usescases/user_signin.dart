import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for signing in a user.
class UserSignIn implements UseCase<UserIntelli, UserSignInParams> {
  UserSignIn(this.repository);

  final AuthRepository repository;

  /// Calls the sign in method of the [AuthRepository] with the provided email and password.
  ///
  /// Returns a [Future] that completes with an [Either] containing a [Failure] or a [UserIntelli].
  @override
  Future<Either<Failure, UserIntelli>> call(UserSignInParams params) async {
    return repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for the user sign in use case.
class UserSignInParams {
  UserSignInParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
