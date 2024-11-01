import 'package:budget_intelli/core/constants/exception_message.dart';
import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserIntelli> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<UserIntelli> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Unit> signOut();

  Future<UserIntelli?> getCurrentUserSession();

  User? get currentUserSession;

  Future<UserIntelli> getUserFirestore();

  Future<UserIntelli> insertUserFirestore(UserIntelli userIntellie);

  Future<UserIntelli> updateUser(UserIntelli userIntellie);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this.auth, this.firestore);

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  @override
  Future<UserIntelli> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final data = UserIntelli(
        uid: response.user!.uid,
        email: email,
        name: name,
        createdAt: Timestamp.now(),
        premium: false,
      ).toMap();

      await firestore
          .collection(FirebaseConstant.users)
          .doc(response.user!.uid)
          .set(data);

      if (response.user != null) {
        return UserIntelli(
          uid: response.user!.uid,
          email: response.user!.email!,
        );
      } else {
        throw CustomException(ExceptionMessage.userEmpty);
      }
    } on FirebaseAuthException catch (e, s) {
      appLogger(
        from: 'signUpWithEmailAndPassword Auth',
        message: e.message,
        code: e.code,
        error: e,
        stackTrace: s,
      );
      throw CustomException(e.code);
    } on FirebaseException catch (e, s) {
      appLogger(
        from: 'signUpWithEmailAndPassword Firebase',
        message: e.message,
        code: e.code,
        error: e,
        stackTrace: s,
      );
      throw CustomException(e.code);
    } catch (e, s) {
      appLogger(
        from: 'signUpWithEmailAndPassword',
        error: e,
        stackTrace: s,
      );
      throw CustomException('${ExceptionMessage.signUp}, $e');
    }
  }

  @override
  Future<UserIntelli> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return UserIntelli(
          email: response.user!.email!,
          uid: response.user!.uid,
        );
      } else {
        throw CustomException(ExceptionMessage.userEmpty);
      }
    } on FirebaseAuthException catch (e, s) {
      appLogger(
        from: 'signInWithEmailAndPassword AuthException',
        message: e.message,
        code: e.code,
        error: e,
        stackTrace: s,
      );
      throw CustomException(
        e.code,
      );
    } catch (e, s) {
      appLogger(
        from: 'signInWithEmailAndPassword',
        error: e,
        stackTrace: s,
      );
      throw CustomException('${ExceptionMessage.signIn}, $e');
    }
  }

  @override
  Future<Unit> signOut() async {
    try {
      await auth.signOut();
      return unit;
    } on FirebaseAuthException catch (e, s) {
      appLogger(
        from: 'signOut AuthException',
        error: e,
        code: e.code,
        message: e.message,
        stackTrace: s,
      );
      throw CustomException(e.code);
    } catch (e, s) {
      appLogger(
        error: e,
        from: 'signOut',
        stackTrace: s,
      );
      throw CustomException('${ExceptionMessage.signOut}, $e');
    }
  }

  @override
  Future<UserIntelli?> getCurrentUserSession() async {
    try {
      if (currentUserSession != null) {
        final userData = auth.currentUser;

        return UserIntelli(
          email: userData!.email!,
          uid: userData.uid,
        ).copyWith(
          email: currentUserSession!.email,
          uid: currentUserSession!.uid,
        );
      } else {
        return null;
      }
    } catch (e, s) {
      appLogger(
        from: 'getCurrentUserSession',
        error: e,
        stackTrace: s,
      );
      throw CustomException('${ExceptionMessage.getCurrentUser}, $e');
    }
  }

  @override
  User? get currentUserSession => auth.currentUser;

  @override
  Future<UserIntelli> getUserFirestore() async {
    try {
      final response = await firestore
          .collection(FirebaseConstant.users)
          .doc(auth.currentUser!.uid)
          .get();

      if (response.exists) {
        return UserIntelli.fromFirestore(response);
      } else {
        throw CustomException(ExceptionMessage.userEmpty);
      }
    } on FirebaseException catch (e, s) {
      appLogger(
        from: 'getUser Firebase',
        error: e,
        code: e.code,
        message: e.message,
        stackTrace: s,
      );
      throw CustomException(e.code);
    } catch (e, s) {
      appLogger(
        from: 'getUser',
        error: e,
        stackTrace: s,
      );
      throw CustomException('${ExceptionMessage.getUser}, $e');
    }
  }

  @override
  Future<UserIntelli> insertUserFirestore(
    UserIntelli userIntellie,
  ) async {
    try {
      final data = userIntellie.toMap();

      await firestore
          .collection(FirebaseConstant.users)
          .doc(userIntellie.uid)
          .set(data);

      return userIntellie;
    } on FirebaseException catch (e, s) {
      appLogger(
        from: 'insertUser Firebase',
        error: e,
        code: e.code,
        message: e.message,
        stackTrace: s,
      );
      throw CustomException(e.code);
    } catch (e, s) {
      appLogger(
        from: 'insertUser',
        error: e,
        stackTrace: s,
      );
      throw CustomException('${ExceptionMessage.insertUser}, $e');
    }
  }

  @override
  Future<UserIntelli> updateUser(
    UserIntelli userIntellie,
  ) async {
    try {
      final data = userIntellie.toMap();

      await firestore
          .collection(FirebaseConstant.users)
          .doc(userIntellie.uid)
          .update(data);

      return userIntellie;
    } on FirebaseException catch (e, s) {
      appLogger(
        from: 'updateUser Firebase',
        error: e,
        code: e.code,
        message: e.message,
        stackTrace: s,
      );
      throw CustomException(e.code);
    } catch (e, s) {
      appLogger(
        from: 'updateUser',
        error: e,
        stackTrace: s,
      );
      throw CustomException('${ExceptionMessage.updateUser}, $e');
    }
  }
}
