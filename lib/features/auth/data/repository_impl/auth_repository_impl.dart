import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  @override
  Future<Either<Failure, UserIntelli>> getCurrentUserSession() async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(
            Failure(ErrorMessages.userNotFound),
          );
        }

        return right(
          UserIntelli(
            uid: session.uid,
            email: session.email ?? '',
          ),
        );
      }
      final user = await remoteDataSource.getCurrentUserSession();
      if (user == null) {
        return left(Failure(ErrorMessages.userNotFound));
      }

      return right(user);
    } on CustomException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserIntelli>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(Failure(ErrorMessages.userNotFound));
        }

        return right(
          UserIntelli(
            uid: session.uid,
            email: session.email ?? '',
          ),
        );
      }
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return right(user);
    } on CustomException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserIntelli>> signUpWithEmailAndPassword(
    UserSignUpParams params,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(Failure(ErrorMessages.userNotFound));
        }

        return right(
          UserIntelli(
            uid: session.uid,
            email: session.email ?? '',
          ),
        );
      }
      final user = await remoteDataSource.signUpWithEmailAndPassword(
        email: params.email,
        password: params.password,
        name: params.name,
      );

      return right(user);
    } on CustomException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() {
    try {
      return remoteDataSource.signOut().then((_) => right(unit));
    } on CustomException catch (e) {
      return Future.value(left<Failure, Unit>(Failure(e.message)));
    }
  }

  @override
  Future<Either<Failure, UserIntelli>> getUserFirestore() async {
    try {
      final userModel = await remoteDataSource.getUserFirestore();
      final userIntelli = UserIntelli(
        uid: userModel.uid,
        email: userModel.email,
        name: userModel.name,
        createdAt: userModel.createdAt,
        premium: userModel.premium,
        imageUrl: userModel.imageUrl,
      );

      return right(userIntelli);
    } on CustomException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserIntelli>> insertUserFirestore(
    UserIntelli userIntellie,
  ) async {
    try {
      await remoteDataSource.insertUserFirestore(userIntellie);

      return right(userIntellie);
    } on CustomException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserIntelli>> updateUserFirestore(
    UserIntelli userIntellie,
  ) async {
    try {
      final user = await remoteDataSource.updateUser(userIntellie);

      return right(user);
    } on CustomException catch (e) {
      return left(Failure(e.message));
    }
  }
}
