part of 'budget_form_bloc.dart';

@immutable
sealed class BudgetFormEvent {}

final class BudgetFormInitial extends BudgetFormEvent {
  BudgetFormInitial({
    required this.generateBudgetAI,
    this.budgetGenerate,
  });

  final bool generateBudgetAI;
  final BudgetGenerateModel? budgetGenerate;
}

final class BudgetFormNew extends BudgetFormEvent {
  BudgetFormNew({
    required this.generateBudgetAI,
    this.budgetGenerate,
  });

  final bool generateBudgetAI;
  final BudgetGenerateModel? budgetGenerate;
}

final class BudgetFormToInitial extends BudgetFormEvent {}

final class BudgetFormInitialNew extends BudgetFormEvent {
  BudgetFormInitialNew({
    required this.budgetId,
    required this.categoryType,
    required this.isExpenses,
  });

  final String budgetId;
  final String categoryType;
  final bool isExpenses;
}

final class RemoveItemCategoryFromInitial extends BudgetFormEvent {
  RemoveItemCategoryFromInitial({
    required this.groupHistoId,
    required this.itemHistoId,
  });

  final String groupHistoId;
  final String itemHistoId;
}

final class RemoveItemCategoryFromInside extends BudgetFormEvent {
  RemoveItemCategoryFromInside({
    required this.groupId,
    required this.itemId,
  });

  final String groupId;
  final String itemId;
}

final class AddItemCategoryHistory extends BudgetFormEvent {
  AddItemCategoryHistory({
    required this.groupId,
    required this.itemCategory,
  });

  final String groupId;
  final ItemCategoryHistory itemCategory;
}

final class UpdateItemCategoryEventInitialCreate extends BudgetFormEvent {
  UpdateItemCategoryEventInitialCreate({
    required this.groupHistoId,
    required this.itemHistoId,
    required this.itemCategoryHistory,
    this.totalIncome,
    this.totalExpense,
  });

  final String groupHistoId;
  final String itemHistoId;
  final ItemCategoryHistory itemCategoryHistory;

  /// total income and total expense is for create new group
  final int? totalIncome;
  final int? totalExpense;
}

final class UpdateItemCategoryHistoryEvent extends BudgetFormEvent {
  UpdateItemCategoryHistoryEvent({
    required this.groupId,
    required this.itemId,
    required this.itemCategory,
    this.totalIncome,
    this.totalExpense,
  });

  final String groupId;
  final String itemId;
  final ItemCategoryHistory itemCategory;
  final int? totalIncome;
  final int? totalExpense;
}

final class UpdateGroupCategoryHistoryType extends BudgetFormEvent {
  UpdateGroupCategoryHistoryType({
    required this.groupId,
    required this.type,
    required this.isExpenses,
  });

  final String groupId;
  final String type;
  final bool isExpenses;
}

final class AddGroupCategoryHistory extends BudgetFormEvent {
  AddGroupCategoryHistory({
    required this.groupCategoryHisto,
  });

  final GroupCategoryHistory groupCategoryHisto;
}

final class RemoveGroupCategoryHistory extends BudgetFormEvent {
  RemoveGroupCategoryHistory({
    required this.groupHistoId,
  });

  final String groupHistoId;
}

final class RemoveGroupCategory extends BudgetFormEvent {
  RemoveGroupCategory({
    required this.groupId,
  });

  final String groupId;
}

final class UpdateGroupCategoryHistory extends BudgetFormEvent {
  UpdateGroupCategoryHistory({
    required this.groupCategoryHistory,
  });

  final GroupCategoryHistory groupCategoryHistory;
}

final class InsertBudgetsToDatabase extends BudgetFormEvent {
  InsertBudgetsToDatabase({
    required this.groupCategoryHistories,
    required this.itemCategoryHistories,
    required this.budget,
    required this.fromInitial,
    this.groupCategories,
    this.itemCategories,
  });

  final List<GroupCategoryHistory> groupCategoryHistories;
  final List<ItemCategoryHistory> itemCategoryHistories;
  final List<GroupCategory>? groupCategories;
  final List<ItemCategory>? itemCategories;
  final Budget budget;
  final bool fromInitial;
}

final class SelectDateRange extends BudgetFormEvent {
  SelectDateRange({
    required this.dateRange,
  });

  final List<DateTime?> dateRange;
}

final class ResetSuccess extends BudgetFormEvent {}

final class UpdateSelectedGroupCategories extends BudgetFormEvent {
  UpdateSelectedGroupCategories({
    required this.groupCategories,
    required this.budgetId,
  });

  final List<GroupCategory> groupCategories;

  final String budgetId;
}

final class UpdateSelectedItemCategoryHistories extends BudgetFormEvent {
  UpdateSelectedItemCategoryHistories({
    required this.itemCategoryHistories,
  });

  final List<ItemCategoryHistory> itemCategoryHistories;
}

final class ApplyGroupCategoryHistories extends BudgetFormEvent {
  ApplyGroupCategoryHistories({required this.budgetId});

  final String budgetId;
}

final class ClearGroupCategoryHistories extends BudgetFormEvent {}

final class GetAllItemCategoryHistoriesEvent extends BudgetFormEvent {}

final class UpdatePortionsEvent extends BudgetFormEvent {
  UpdatePortionsEvent({required this.groupCategories});

  final List<GroupCategoryHistory> groupCategories;
}
