part of 'budget_bloc.dart';

@immutable
sealed class BudgetState {}

final class BudgetInitial extends BudgetState {}

final class BudgetLoading extends BudgetState {}

final class BudgetUpdated extends BudgetState {}

final class GetGroupBudgetLoaded extends BudgetState {
  GetGroupBudgetLoaded({
    required this.groupCategoryList,
  });

  final List<GroupCategoryHistory> groupCategoryList;
}

final class GetBudgetsLoaded extends BudgetState {
  GetBudgetsLoaded({
    this.budget,
    this.budgets,
    this.totalActualExpense = 0,
    this.totalActualIncome = 0,
    this.itemCategoryTransactionsByBudgetId = const [],
  });

  final Budget? budget;
  final List<Budget>? budgets;
  final int totalActualExpense;
  final int totalActualIncome;
  final List<ItemCategoryTransaction> itemCategoryTransactionsByBudgetId;

  GetBudgetsLoaded copyWith({
    Budget? budget,
    List<Budget>? budgets,
    int? totalActualExpense,
    int? totalActualIncome,
    List<ItemCategoryTransaction>? itemCategoryTransactionsByBudgetId,
  }) {
    return GetBudgetsLoaded(
      budget: budget ?? this.budget,
      budgets: budgets ?? this.budgets,
      totalActualExpense: totalActualExpense ?? this.totalActualExpense,
      totalActualIncome: totalActualIncome ?? this.totalActualIncome,
      itemCategoryTransactionsByBudgetId: itemCategoryTransactionsByBudgetId ?? this.itemCategoryTransactionsByBudgetId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetBudgetsLoaded &&
          runtimeType == other.runtimeType &&
          budget == other.budget &&
          budgets == other.budgets &&
          totalActualExpense == other.totalActualExpense &&
          totalActualIncome == other.totalActualIncome &&
          itemCategoryTransactionsByBudgetId == other.itemCategoryTransactionsByBudgetId;

  @override
  int get hashCode =>
      budget.hashCode ^
      budgets.hashCode ^
      totalActualExpense.hashCode ^
      totalActualIncome.hashCode ^
      itemCategoryTransactionsByBudgetId.hashCode;
}

final class BudgetError extends BudgetState {
  BudgetError({
    required this.failure,
  });

  final Failure failure;
}

final class SuccessUpdateGroupCategoryHistory extends BudgetState {}

final class FailureUpdateGroupCategoryHistory extends BudgetState {
  FailureUpdateGroupCategoryHistory(this.message);

  final String message;
}
