part of 'budget_firestore_cubit.dart';

@immutable
class BudgetFirestoreState {
  const BudgetFirestoreState({
    this.loadingFirestore = false,
    this.insertItemHistoryFireSuccess = false,
    this.errorMessage,
    this.initial = false,
    this.insertGroupCategoryHistorySuccess = false,
    this.insertBudgetToFirestoreSuccess = false,
    this.updateItemHistoryFireSuccess = false,
    this.deleteItemHistoryFireSuccess = false,
    this.insertItemCategoryTransactionSuccess = false,
    this.insertAccountSuccess = false,
    this.updateAccountSuccess = false,
    this.transferSuccess = false,
  });

  final bool loadingFirestore;
  final bool insertItemHistoryFireSuccess;
  final String? errorMessage;
  final bool initial;
  final bool insertGroupCategoryHistorySuccess;
  final bool insertBudgetToFirestoreSuccess;
  final bool updateItemHistoryFireSuccess;
  final bool deleteItemHistoryFireSuccess;
  final bool insertItemCategoryTransactionSuccess;
  final bool insertAccountSuccess;
  final bool updateAccountSuccess;
  final bool transferSuccess;

  BudgetFirestoreState copyWith({
    bool? loadingFirestore,
    bool? insertItemHistoryFireSuccess,
    String? errorMessage,
    bool? initial,
    bool? insertGroupCategoryHistorySuccess,
    bool? insertBudgetToFirestoreSuccess,
    bool? updateItemHistoryFireSuccess,
    bool? deleteItemHistoryFireSuccess,
    bool? insertItemCategoryTransactionSuccess,
    bool? insertAccountSuccess,
    bool? updateAccountSuccess,
    bool? transferSuccess,
  }) {
    return BudgetFirestoreState(
      loadingFirestore: loadingFirestore ?? this.loadingFirestore,
      insertItemHistoryFireSuccess: insertItemHistoryFireSuccess ?? this.insertItemHistoryFireSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      initial: initial ?? this.initial,
      insertGroupCategoryHistorySuccess: insertGroupCategoryHistorySuccess ?? this.insertGroupCategoryHistorySuccess,
      insertBudgetToFirestoreSuccess: insertBudgetToFirestoreSuccess ?? this.insertBudgetToFirestoreSuccess,
      updateItemHistoryFireSuccess: updateItemHistoryFireSuccess ?? this.updateItemHistoryFireSuccess,
      deleteItemHistoryFireSuccess: deleteItemHistoryFireSuccess ?? this.deleteItemHistoryFireSuccess,
      insertItemCategoryTransactionSuccess:
          insertItemCategoryTransactionSuccess ?? this.insertItemCategoryTransactionSuccess,
      insertAccountSuccess: insertAccountSuccess ?? this.insertAccountSuccess,
      updateAccountSuccess: updateAccountSuccess ?? this.updateAccountSuccess,
      transferSuccess: transferSuccess ?? this.transferSuccess,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BudgetFirestoreState &&
        other.loadingFirestore == loadingFirestore &&
        other.insertItemHistoryFireSuccess == insertItemHistoryFireSuccess &&
        other.errorMessage == errorMessage &&
        other.initial == initial &&
        other.insertGroupCategoryHistorySuccess == insertGroupCategoryHistorySuccess &&
        other.insertBudgetToFirestoreSuccess == insertBudgetToFirestoreSuccess &&
        other.updateItemHistoryFireSuccess == updateItemHistoryFireSuccess &&
        other.deleteItemHistoryFireSuccess == deleteItemHistoryFireSuccess &&
        other.insertItemCategoryTransactionSuccess == insertItemCategoryTransactionSuccess &&
        other.insertAccountSuccess == insertAccountSuccess &&
        other.updateAccountSuccess == updateAccountSuccess &&
        other.transferSuccess == transferSuccess;
  }

  @override
  int get hashCode =>
      loadingFirestore.hashCode ^
      insertItemHistoryFireSuccess.hashCode ^
      errorMessage.hashCode ^
      initial.hashCode ^
      insertGroupCategoryHistorySuccess.hashCode ^
      insertBudgetToFirestoreSuccess.hashCode ^
      updateItemHistoryFireSuccess.hashCode ^
      deleteItemHistoryFireSuccess.hashCode ^
      insertItemCategoryTransactionSuccess.hashCode ^
      insertAccountSuccess.hashCode ^
      updateAccountSuccess.hashCode ^
      transferSuccess.hashCode;
}
