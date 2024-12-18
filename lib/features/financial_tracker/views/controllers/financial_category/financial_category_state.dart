part of 'financial_category_bloc.dart';

final class FinancialCategoryState extends Equatable {
  const FinancialCategoryState({
    this.insertSuccess = false,
    this.updateSuccess = false,
    this.deleteSuccess = false,
    this.financialCategories = const [],
    this.financialCategory,
    this.errorMessage,
    this.selectedFinancialCategory,
  });

  final bool insertSuccess;
  final bool updateSuccess;
  final bool deleteSuccess;
  final String? errorMessage;
  final List<FinancialCategory> financialCategories;
  final FinancialCategory? financialCategory;
  final FinancialCategory? selectedFinancialCategory;

  FinancialCategoryState copyWith({
    bool? insertSuccess,
    bool? updateSuccess,
    bool? deleteSuccess,
    List<FinancialCategory>? financialCategories,
    FinancialCategory? financialCategory,
    String? errorMessage,
    FinancialCategory? selectedFinancialCategory,
  }) {
    return FinancialCategoryState(
      insertSuccess: insertSuccess ?? this.insertSuccess,
      updateSuccess: updateSuccess ?? this.updateSuccess,
      deleteSuccess: deleteSuccess ?? this.deleteSuccess,
      financialCategories: financialCategories ?? this.financialCategories,
      financialCategory: financialCategory ?? this.financialCategory,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedFinancialCategory:
          selectedFinancialCategory ?? this.selectedFinancialCategory,
    );
  }

  @override
  List<Object?> get props => [
        insertSuccess,
        updateSuccess,
        deleteSuccess,
        financialCategories,
        financialCategory,
        errorMessage,
        selectedFinancialCategory,
      ];
}
