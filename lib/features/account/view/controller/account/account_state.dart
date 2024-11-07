part of 'account_bloc.dart';

@immutable
final class AccountState {
  const AccountState({
    required this.accounts,
    required this.selectedAccount,
    this.insertSuccess = false,
    this.updateSuccess = false,
    this.transferSuccess = false,
    this.error,
    this.accountTypes = const [],
    this.accountHistory = const [],
    this.itemCategoryTransactions = const [],
    this.itemCategoryHistories = const [],
    this.newAccountParam,
    this.updatedFirstAccountParam,
    this.updatedSecondAccountParam,
    this.totalBalance,
  });

  factory AccountState.initial() {
    return const AccountState(
      accounts: [],
      selectedAccount: null,
    );
  }

  final List<Account> accounts;
  final Account? selectedAccount;
  final List<AccountHistory> accountHistory;
  final List<ItemCategoryTransaction> itemCategoryTransactions;
  final bool insertSuccess;
  final bool updateSuccess;
  final bool transferSuccess;
  final String? error;
  final List<String> accountTypes;
  final List<ItemCategoryHistory> itemCategoryHistories;
  final Account? newAccountParam;
  final Account? updatedFirstAccountParam;
  final Account? updatedSecondAccountParam;
  final double? totalBalance;

  AccountState copyWith({
    List<Account>? accounts,
    List<AccountHistory>? accountHistory,
    Account? selectedAccount,
    bool? insertSuccess,
    bool? updateSuccess,
    bool? transferSuccess,
    String? error,
    List<String>? accountTypes,
    List<ItemCategoryTransaction>? itemCategoryTransactions,
    List<ItemCategoryHistory>? itemCategoryHistories,
    Account? newAccountParam,
    Account? updatedFirstAccountParam,
    Account? updatedSecondAccountParam,
    bool? isEdit,
    double? totalBalance,
  }) {
    return AccountState(
      accounts: accounts ?? this.accounts,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      insertSuccess: insertSuccess ?? this.insertSuccess,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      transferSuccess: transferSuccess ?? this.transferSuccess,
      error: error ?? this.error,
      accountTypes: accountTypes ?? this.accountTypes,
      accountHistory: accountHistory ?? this.accountHistory,
      itemCategoryHistories:
          itemCategoryHistories ?? this.itemCategoryHistories,
      itemCategoryTransactions:
          itemCategoryTransactions ?? this.itemCategoryTransactions,
      newAccountParam: newAccountParam ?? this.newAccountParam,
      updatedFirstAccountParam:
          updatedFirstAccountParam ?? this.updatedFirstAccountParam,
      updatedSecondAccountParam:
          updatedSecondAccountParam ?? this.updatedSecondAccountParam,
      totalBalance: totalBalance ?? this.totalBalance,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccountState &&
        listEquals(other.accounts, accounts) &&
        listEquals(other.accountHistory, accountHistory) &&
        other.selectedAccount == selectedAccount &&
        other.insertSuccess == insertSuccess &&
        other.updateSuccess == updateSuccess &&
        other.transferSuccess == transferSuccess &&
        other.error == error &&
        listEquals(other.accountTypes, accountTypes) &&
        listEquals(other.itemCategoryHistories, itemCategoryHistories) &&
        listEquals(other.itemCategoryTransactions, itemCategoryTransactions) &&
        other.newAccountParam == newAccountParam &&
        other.updatedFirstAccountParam == updatedFirstAccountParam &&
        other.updatedSecondAccountParam == updatedSecondAccountParam &&
        other.totalBalance == totalBalance;
  }

  @override
  int get hashCode =>
      accounts.hashCode ^
      selectedAccount.hashCode ^
      insertSuccess.hashCode ^
      updateSuccess.hashCode ^
      transferSuccess.hashCode ^
      error.hashCode ^
      accountTypes.hashCode ^
      accountHistory.hashCode ^
      itemCategoryTransactions.hashCode ^
      itemCategoryHistories.hashCode ^
      newAccountParam.hashCode ^
      updatedFirstAccountParam.hashCode ^
      updatedSecondAccountParam.hashCode ^
      totalBalance.hashCode;
}
