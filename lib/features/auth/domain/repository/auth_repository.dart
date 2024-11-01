import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserIntelli>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserIntelli>> signUpWithEmailAndPassword(
    UserSignUpParams userIntelli,
  );

  Future<Either<Failure, UserIntelli>> getCurrentUserSession();

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, UserIntelli>> getUserFirestore();

  // insert user data
  Future<Either<Failure, UserIntelli>> insertUserFirestore(
    UserIntelli userIntelli,
  );

  // update user data
  Future<Either<Failure, UserIntelli>> updateUserFirestore(
    UserIntelli userIntelli,
  );
}
