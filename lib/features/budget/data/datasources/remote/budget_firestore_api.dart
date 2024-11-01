import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BudgetFirestoreApi {
// budget
  Future<List<Budget>> getBudgetsFirestore();

  Future<Unit> insertBudgetFirestore(Budget budget);

//   group category history
  Future<List<GroupCategoryHistory>> getGroupCategoryHistoriesFirestore();

  Future<Unit> insertGroupCategoryHistoryFirestore(
    GroupCategoryHistory groupCategoryHistory,
  );

//   group category
  Future<List<GroupCategory>> getGroupCategoriesFirestore();

  Future<Unit> insertGroupCategoryFirestore(GroupCategory groupCategory);

//   item category history
  Future<List<ItemCategoryHistory>> getItemCategoryHistoriesFirestore();

  Future<Unit> insertItemCategoryHistoryFirestore(
    ItemCategoryHistory itemCategoryHistory,
  );

  Future<Unit> updateItemCategoryHistoryFirestore(
    ItemCategoryHistory itemCategoryHistory,
  );

  Future<Unit> deleteItemCategoryHistoryFirestore(
    String id,
  );

//   item category
  Future<List<ItemCategory>> getItemCategoriesFirestore();

  Future<Unit> insertItemCategoryFirestore(ItemCategory itemCategory);

  Future<Unit> updateItemCategoryFirestore(ItemCategory itemCategory);

//   item category transaction
  Future<List<ItemCategoryTransaction>> getItemCategoryTransactionsFirestore();

  Future<Unit> insertItemCategoryTransactionFirestore(
    ItemCategoryTransaction itemCategoryTransaction,
  );
}

class BudgetFirestoreApiImpl implements BudgetFirestoreApi {
  BudgetFirestoreApiImpl({
    required this.firestore,
    required this.auth,
  });

  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  @override
  Future<List<Budget>> getBudgetsFirestore() async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        final response = await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.budgets)
            .get();

        return response.docs.map(Budget.fromFirestore).toList();
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> insertBudgetFirestore(Budget budget) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.budgets)
            .doc(budget.id)
            .set(budget.toJson());
      }
      return unit;
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<List<GroupCategoryHistory>> getGroupCategoryHistoriesFirestore() async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        final response = await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.groupCategoryHistories)
            .get();

        return response.docs.map(GroupCategoryHistory.fromFirestore).toList();
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> insertGroupCategoryHistoryFirestore(
    GroupCategoryHistory groupCategoryHistory,
  ) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.groupCategoryHistories)
            .doc(groupCategoryHistory.id)
            .set(groupCategoryHistory.toFirestoreWithoutItemCategories());
      }
      return unit;
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<List<GroupCategory>> getGroupCategoriesFirestore() async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        final response = await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.groupCategories)
            .get();

        return response.docs.map(GroupCategory.fromFirestore).toList();
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> insertGroupCategoryFirestore(
    GroupCategory groupCategory,
  ) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.groupCategories)
            .doc(groupCategory.id)
            .set(groupCategory.toFirestore());
      }
      return unit;
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<List<ItemCategoryHistory>> getItemCategoryHistoriesFirestore() async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        final response = await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.itemCategoryHistories)
            .get();

        return response.docs.map(ItemCategoryHistory.fromFirestore).toList();
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> insertItemCategoryHistoryFirestore(
    ItemCategoryHistory itemCategoryHistory,
  ) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.itemCategoryHistories)
            .doc(itemCategoryHistory.id)
            .set(itemCategoryHistory.toFirestore());
      }
      return unit;
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<List<ItemCategory>> getItemCategoriesFirestore() async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        final response = await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.itemCategories)
            .get();

        return response.docs.map(ItemCategory.fromFirestore).toList();
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> insertItemCategoryFirestore(
    ItemCategory itemCategory,
  ) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.itemCategories)
            .doc(itemCategory.id)
            .set(itemCategory.toFirestore());
      }
      return unit;
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<List<ItemCategoryTransaction>> getItemCategoryTransactionsFirestore() async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        final response = await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.itemCategoryTransactions)
            .get();

        return response.docs.map(ItemCategoryTransaction.fromFirestore).toList();
      }
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> insertItemCategoryTransactionFirestore(
    ItemCategoryTransaction itemCategoryTransaction,
  ) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.itemCategoryTransactions)
            .doc(itemCategoryTransaction.id)
            .set(itemCategoryTransaction.toFirestore());
      }
      return unit;
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> deleteItemCategoryHistoryFirestore(String id) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.itemCategoryHistories)
            .doc(id)
            .delete();
      }
      return unit;
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> updateItemCategoryFirestore(ItemCategory itemCategory) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.itemCategories)
            .doc(itemCategory.id)
            .update(itemCategory.toFirestore());
      }
      return unit;
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }

  @override
  Future<Unit> updateItemCategoryHistoryFirestore(ItemCategoryHistory itemCategoryHistory) async {
    try {
      if (auth.currentUser == null) {
        throw CustomException('User is not logged in');
      } else {
        await firestore
            .collection(FirebaseConstant.users)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConstant.itemCategoryHistories)
            .doc(itemCategoryHistory.id)
            .update(itemCategoryHistory.toFirestore());
      }
      return unit;
    } on FirebaseException catch (e) {
      throw CustomException('Firestore failure: ${e.message}');
    }
  }
}
