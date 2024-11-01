part of 'budget_bloc.dart';

@immutable
sealed class BudgetEvent {}

final class BudgetBlocInitial extends BudgetEvent {}

final class GetGroupBudgetCategoryHistory extends BudgetEvent {}

final class GetBudgetsByIdEvent extends BudgetEvent {
  GetBudgetsByIdEvent({
    required this.id,
    this.prevBudget,
  });

  final String id;
  final Budget? prevBudget;
}

final class UpdateBudgetDBEvent extends BudgetEvent {
  UpdateBudgetDBEvent({required this.budget});

  final Budget budget;
}

final class UpdateGroupCategoryHistoryEvent extends BudgetEvent {
  UpdateGroupCategoryHistoryEvent({required this.groupCategoryHistory});

  final GroupCategoryHistory groupCategoryHistory;
}
