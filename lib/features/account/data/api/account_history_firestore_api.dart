import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AccountHistoryFirestoreApi {
  Future<AccountHistory?> getAccountHistoryFireById(String id);

  Future<List<AccountHistory>> getAccountHistoriesFire();

  Future<Unit> insertAccountHistoryFire(AccountHistory account);

  Future<Unit> deleteAccountHistoryFire(String id);

  Future<Unit> updateAccountHistoryFire(AccountHistory account);
}

class AccountHistoryFirestoreApiImpl implements AccountHistoryFirestoreApi {
  AccountHistoryFirestoreApiImpl(
    this.firestore,
    this.auth,
  );

  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  @override
  Future<Unit> deleteAccountHistoryFire(String id) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.accountHistories)
            .doc(id)
            .delete();

        return unit;
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<List<AccountHistory>> getAccountHistoriesFire() async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        final snapshot = await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.accountHistories)
            .get();

        return snapshot.docs
            .map((doc) => AccountHistory.fromMap(doc.data()))
            .toList();
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<AccountHistory?> getAccountHistoryFireById(String id) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        final snapshot = await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.accountHistories)
            .doc(id)
            .get();

        return snapshot.exists
            ? AccountHistory.fromMap(snapshot.data()!)
            : null;
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> insertAccountHistoryFire(AccountHistory account) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.accountHistories)
            .doc(account.id)
            .set(account.toMap());

        return unit;
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> updateAccountHistoryFire(AccountHistory account) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.accountHistories)
            .doc(account.id)
            .update(account.toMap());

        return unit;
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }
}
