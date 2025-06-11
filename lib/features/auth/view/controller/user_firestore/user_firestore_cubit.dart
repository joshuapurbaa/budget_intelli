import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'user_firestore_state.dart';

class UserFirestoreCubit extends Cubit<UserFirestoreState> {
  UserFirestoreCubit({
    required GetUserFirestoreUsecase getUser,
    required UpdateUserFirestoreUsecases updateUser,
    required InsertUserFirestoreUsecase insertUserDataUsecase,
  })  : _getUserFirestore = getUser,
        _updateUser = updateUser,
        _insertUserDataUsecase = insertUserDataUsecase,
        super(
          const UserFirestoreState(
            userIntellie: null,
            message: '',
            isLoading: false,
          ),
        );

  final GetUserFirestoreUsecase _getUserFirestore;
  final UpdateUserFirestoreUsecases _updateUser;
  final InsertUserFirestoreUsecase _insertUserDataUsecase;

  Future<UserIntelli?> getUserFirestore() async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );

    final result = await _getUserFirestore(NoParams());

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            message: failure.message,
            isLoading: false,
          ),
        );

        return null;
      },
      (user) {
        emit(
          state.copyWith(
            userIntellie: user,
            isLoading: false,
          ),
        );

        return user;
      },
    );

    if (result.isLeft()) {
      return null;
    } else {
      return state.userIntellie;
    }
  }

  Future<void> updateUser(UserIntelli userIntellie) async {
    emit(
      state.copyWith(
        isLoading: true,
        updateSuccess: false,
      ),
    );

    final result = await _updateUser(userIntellie);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            message: failure.message,
            isLoading: false,
          ),
        );
      },
      (user) {
        emit(
          state.copyWith(
            userIntellie: user,
            isLoading: false,
            updateSuccess: true,
          ),
        );
      },
    );
  }

  Future<UserIntelli?> insertUser(UserIntelli userIntellie) async {
    emit(
      state.copyWith(
        isLoading: true,
        updateSuccess: false,
      ),
    );

    final result = await _insertUserDataUsecase(userIntellie);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            message: failure.message,
            isLoading: false,
          ),
        );

        return null;
      },
      (user) {
        emit(
          state.copyWith(
            userIntellie: user,
            isLoading: false,
            updateSuccess: true,
          ),
        );

        return user;
      },
    );

    if (result.isLeft()) {
      return null;
    } else {
      return state.userIntellie;
    }
  }

  Future<void> listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        final valid = await _verifyPurchase(purchaseDetails);

        if (valid) {
          await _handleSuccessfulPurchase(purchaseDetails);
        }
      }

      if (purchaseDetails.status == PurchaseStatus.error) {}

      if (purchaseDetails.status == PurchaseStatus.canceled) {}

      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(
    PurchaseDetails purchaseDetails,
  ) async {
    if (purchaseDetails.productID == AppStrings.annualSubscription ||
        purchaseDetails.productID == AppStrings.monthlySubscription) {
      final user = state.userIntellie;

      if (user != null) {
        final updatedUser = user.copyWith(
          premium: true,
        );
        await updateUser(updatedUser);
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      final verifier =
          FirebaseFunctions.instance.httpsCallable('verifyPurchase');
      final results = await verifier<bool>({
        'source': purchaseDetails.verificationData.source,
        'verificationData':
            purchaseDetails.verificationData.serverVerificationData,
        'productId': purchaseDetails.productID,
      });

      return results.data;
    } on FirebaseFunctionsException catch (_) {
      return false;
    } on Exception {
      return false;
    }
  }
}
