part of 'search_transaction_cubit.dart';

@immutable
final class SearchTransactionState {
  const SearchTransactionState({
    required this.searchTransactions,
    required this.itemCategoryHistoriesFrequency,
    required this.transactionsFrequency,
    required this.titleFrequency,
  });

  final List<ItemCategoryTransaction> searchTransactions;
  final List<ItemCategoryTransaction> transactionsFrequency;
  final List<ItemCategoryHistory> itemCategoryHistoriesFrequency;
  final String titleFrequency;

  SearchTransactionState copyWith({
    List<ItemCategoryTransaction>? searchTransactions,
    List<ItemCategoryHistory>? itemCategoryHistoriesFrequency,
    List<ItemCategoryTransaction>? transactionsFrequency,
    String? titleFrequency,
  }) {
    return SearchTransactionState(
      searchTransactions: searchTransactions ?? this.searchTransactions,
      itemCategoryHistoriesFrequency:
          itemCategoryHistoriesFrequency ?? this.itemCategoryHistoriesFrequency,
      transactionsFrequency:
          transactionsFrequency ?? this.transactionsFrequency,
      titleFrequency: titleFrequency ?? this.titleFrequency,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchTransactionState &&
        listEquals(other.searchTransactions, searchTransactions) &&
        listEquals(
          other.itemCategoryHistoriesFrequency,
          itemCategoryHistoriesFrequency,
        ) &&
        listEquals(other.transactionsFrequency, transactionsFrequency) &&
        other.titleFrequency == titleFrequency;
  }

  @override
  int get hashCode =>
      searchTransactions.hashCode ^
      itemCategoryHistoriesFrequency.hashCode ^
      transactionsFrequency.hashCode ^
      titleFrequency.hashCode;
}
