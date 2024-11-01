import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_transaction_state.dart';

class SearchTransactionCubit extends Cubit<SearchTransactionState> {
  SearchTransactionCubit()
      : super(
          const SearchTransactionState(
            searchTransactions: <ItemCategoryTransaction>[],
            itemCategoryHistoriesFrequency: <ItemCategoryHistory>[],
            transactionsFrequency: <ItemCategoryTransaction>[],
            titleFrequency: '',
          ),
        );

  void setItemCategoriesFrequency(
    List<ItemCategoryHistory> itemCategoriesFrequency,
    List<ItemCategoryTransaction> transactionsFrequency,
    String titleFrequency,
  ) {
    emit(
      state.copyWith(
        itemCategoryHistoriesFrequency: itemCategoriesFrequency,
        transactionsFrequency: transactionsFrequency,
        titleFrequency: titleFrequency,
      ),
    );
  }

  void searchTransaction(
    String query,
    List<ItemCategoryTransaction> transactions,
  ) {
    final searchResult = transactions.where(
      (element) {
        final queryLower = query.toLowerCase();
        final title = element.spendOn.toLowerCase();
        final createdAt = element.createdAt.toLowerCase();
        final amount = element.amount.toString().toLowerCase();

        return title.contains(queryLower) ||
            createdAt.contains(queryLower) ||
            amount.contains(queryLower);
      },
    ).toList();

    emit(
      state.copyWith(
        searchTransactions: searchResult,
      ),
    );
  }
}
