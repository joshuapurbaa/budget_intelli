import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AccountFirestoreApi {
  Future<Account?> getAccountByIdFire(String id);

  Future<List<Account>> getAccountsFire();

  Future<Unit> insertAccountFire(Account account);

  Future<Unit> deleteAccountFire(String id);

  Future<Unit> updateAccountFire(Account account);
}

class AccountFirestoreApiImpl implements AccountFirestoreApi {
  AccountFirestoreApiImpl(
    this.firestore,
    this.auth,
  );

  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  @override
  Future<Unit> deleteAccountFire(String id) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.accounts)
            .doc(id)
            .delete();

        return unit;
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Account?> getAccountByIdFire(String id) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        final snapshot = await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.accounts)
            .doc(id)
            .get();

        if (snapshot.exists) {
          return Account.fromMap(snapshot.data()!);
        } else {
          return null;
        }
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<List<Account>> getAccountsFire() async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        final snapshot = await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.accounts)
            .get();

        return snapshot.docs.map((doc) => Account.fromMap(doc.data())).toList();
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> insertAccountFire(Account account) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.accounts)
            .doc(account.id)
            .set(account.toMap());

        return unit;
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> updateAccountFire(Account account) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.accounts)
            .doc(account.id)
            .update(account.toMap());

        return unit;
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }
}
