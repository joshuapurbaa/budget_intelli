part of 'financial_category_history_bloc.dart';

final class FinancialCategoryHistoryState extends Equatable {
  const FinancialCategoryHistoryState({
    this.insertSuccess = false,
    this.updateSuccess = false,
    this.deleteSuccess = false,
    this.financialCategoryHistories = const [],
    this.financialCategoryHistory,
    this.errorMessage,
  });

  final bool insertSuccess;
  final bool updateSuccess;
  final bool deleteSuccess;
  final String? errorMessage;
  final List<FinancialCategoryHistory> financialCategoryHistories;
  final FinancialCategoryHistory? financialCategoryHistory;

  FinancialCategoryHistoryState copyWith({
    bool? insertSuccess,
    bool? updateSuccess,
    bool? deleteSuccess,
    List<FinancialCategoryHistory>? financialCategoryHistories,
    FinancialCategoryHistory? financialCategoryHistory,
    String? errorMessage,
  }) {
    return FinancialCategoryHistoryState(
      insertSuccess: insertSuccess ?? this.insertSuccess,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      deleteSuccess: deleteSuccess ?? this.deleteSuccess,
      financialCategoryHistories:
          financialCategoryHistories ?? this.financialCategoryHistories,
      financialCategoryHistory:
          financialCategoryHistory ?? this.financialCategoryHistory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        insertSuccess,
        updateSuccess,
        deleteSuccess,
        financialCategoryHistories,
        financialCategoryHistory,
        errorMessage,
      ];
}
