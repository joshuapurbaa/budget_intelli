part of 'budget_form_bloc.dart';

final class BudgetFormState {
  const BudgetFormState({
    required this.groupCategoryHistories,
    required this.totalPlanIncome,
    required this.totalPlanExpense,
    required this.loading,
    this.totalBalance,
    this.insertBudgetSuccess,
    this.insertItemSuccess = false,
    this.insertGroupSuccess = false,
    this.initial = false,
    this.message = '',
    this.startDate,
    this.endDate,
    this.dateRange = const <DateTime>[],
    this.selectedGroupCategories = const [],
    this.allItemCategoryHistories = const [],
    this.selectedItemCategoryHistories = const [],
    this.portions = const [],
    this.groupCategoryHistoriesParams = const [],
    this.itemCategoryHistoriesParams = const [],
    this.groupCategoriesParams,
    this.budgetParams,
    this.itemCategoriesParams,
    this.budgetName,
  });

  factory BudgetFormState.initial() {
    return const BudgetFormState(
      groupCategoryHistories: [],
      totalPlanIncome: 0.0,
      totalPlanExpense: 0.0,
      loading: false,
      initial: true,
    );
  }

  final List<GroupCategoryHistory> groupCategoryHistories;
  final List<GroupCategory> selectedGroupCategories;
  final double totalPlanIncome;
  final double totalPlanExpense;
  final double? totalBalance;
  final bool? insertBudgetSuccess;
  final bool insertItemSuccess;
  final bool insertGroupSuccess;
  final bool initial;
  final String message;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<DateTime?> dateRange;
  final bool loading;
  final List<ItemCategoryHistory> allItemCategoryHistories;
  final List<ItemCategoryHistory> selectedItemCategoryHistories;
  final List<double> portions;
  final List<GroupCategoryHistory> groupCategoryHistoriesParams;
  final List<ItemCategoryHistory> itemCategoryHistoriesParams;
  final Budget? budgetParams;
  final List<GroupCategory>? groupCategoriesParams;
  final List<ItemCategory>? itemCategoriesParams;
  final String? budgetName;
  BudgetFormState copyWith({
    List<GroupCategoryHistory>? groupCategoryHistories,
    double? totalPlanIncome,
    bool? insertBudgetSuccess,
    bool? insertItemSuccess,
    bool? insertGroupSuccess,
    bool? initial,
    double? totalPlanExpense,
    String? message,
    DateTime? startDate,
    DateTime? endDate,
    List<DateTime?>? dateRange,
    double? totalBalance,
    bool? loading,
    List<GroupCategory>? selectedGroupCategories,
    List<ItemCategoryHistory>? allItemCategoryHistories,
    List<ItemCategoryHistory>? selectedItemCategoryHistories,
    List<double>? portions,
    bool? insertFirestoreLoading,
    bool? insertFirestoreSuccess,
    List<GroupCategoryHistory>? groupCategoryHistoriesParams,
    List<ItemCategoryHistory>? itemCategoryHistoriesParams,
    Budget? budgetParams,
    List<GroupCategory>? groupCategoriesParams,
    List<ItemCategory>? itemCategoriesParams,
    String? budgetName,
  }) {
    return BudgetFormState(
      totalPlanIncome: totalPlanIncome ?? this.totalPlanIncome,
      groupCategoryHistories:
          groupCategoryHistories ?? this.groupCategoryHistories,
      totalPlanExpense: totalPlanExpense ?? this.totalPlanExpense,
      insertBudgetSuccess: insertBudgetSuccess ?? this.insertBudgetSuccess,
      insertItemSuccess: insertItemSuccess ?? this.insertItemSuccess,
      insertGroupSuccess: insertGroupSuccess ?? this.insertGroupSuccess,
      initial: initial ?? this.initial,
      message: message ?? this.message,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dateRange: dateRange ?? this.dateRange,
      totalBalance: totalBalance ?? this.totalBalance,
      loading: loading ?? this.loading,
      selectedGroupCategories:
          selectedGroupCategories ?? this.selectedGroupCategories,
      allItemCategoryHistories:
          allItemCategoryHistories ?? this.allItemCategoryHistories,
      selectedItemCategoryHistories:
          selectedItemCategoryHistories ?? this.selectedItemCategoryHistories,
      portions: portions ?? this.portions,
      groupCategoryHistoriesParams:
          groupCategoryHistoriesParams ?? this.groupCategoryHistoriesParams,
      itemCategoryHistoriesParams:
          itemCategoryHistoriesParams ?? this.itemCategoryHistoriesParams,
      budgetParams: budgetParams ?? this.budgetParams,
      groupCategoriesParams:
          groupCategoriesParams ?? this.groupCategoriesParams,
      itemCategoriesParams: itemCategoriesParams ?? this.itemCategoriesParams,
      budgetName: budgetName ?? this.budgetName,
    );
  }
}
