part of 'budget_form_bloc.dart';

@immutable
final class BudgetFormState {
  const BudgetFormState({
    required this.groupCategoryHistories,
    required this.totalPlanIncome,
    required this.totalPlanExpense,
    required this.loading,
    this.totalBalance,
    this.insertBudgetSuccess = false,
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
  final bool insertBudgetSuccess;
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
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BudgetFormState &&
        listEquals(other.groupCategoryHistories, groupCategoryHistories) &&
        other.totalPlanIncome == totalPlanIncome &&
        other.totalPlanExpense == totalPlanExpense &&
        other.insertBudgetSuccess == insertBudgetSuccess &&
        other.insertItemSuccess == insertItemSuccess &&
        other.insertGroupSuccess == insertGroupSuccess &&
        other.initial == initial &&
        other.message == message &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.dateRange == dateRange &&
        other.totalBalance == totalBalance &&
        other.loading == loading &&
        listEquals(other.selectedGroupCategories, selectedGroupCategories) &&
        listEquals(other.allItemCategoryHistories, allItemCategoryHistories) &&
        listEquals(other.portions, portions) &&
        listEquals(
          other.selectedItemCategoryHistories,
          selectedItemCategoryHistories,
        ) &&
        listEquals(
          other.groupCategoryHistoriesParams,
          groupCategoryHistoriesParams,
        ) &&
        listEquals(
          other.itemCategoryHistoriesParams,
          itemCategoryHistoriesParams,
        ) &&
        other.budgetParams == budgetParams &&
        listEquals(other.groupCategoriesParams, groupCategoriesParams) &&
        listEquals(other.itemCategoriesParams, itemCategoriesParams);
  }

  @override
  int get hashCode =>
      groupCategoryHistories.hashCode ^
      totalPlanIncome.hashCode ^
      totalPlanExpense.hashCode ^
      insertBudgetSuccess.hashCode ^
      insertItemSuccess.hashCode ^
      insertGroupSuccess.hashCode ^
      initial.hashCode ^
      message.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      dateRange.hashCode ^
      totalBalance.hashCode ^
      loading.hashCode ^
      selectedGroupCategories.hashCode ^
      allItemCategoryHistories.hashCode ^
      portions.hashCode ^
      selectedItemCategoryHistories.hashCode ^
      groupCategoryHistoriesParams.hashCode ^
      itemCategoryHistoriesParams.hashCode ^
      budgetParams.hashCode ^
      groupCategoriesParams.hashCode ^
      itemCategoriesParams.hashCode;
}
