part of 'category_cubit.dart';

@immutable
final class CategoryState {
  const CategoryState({
    this.itemCategoryHistory,
    this.hexColor,
    this.failure,
    this.successUpdate = false,
    this.successDelete,
    this.itemCategoryTransactions = const [],
    this.groupCategoryHistories,
    this.budget,
    this.addNewItemCategory = false,
    this.groupCategoryHistory,
    this.successInsert = false,
    this.itemCategoryTransaction,
    this.successDeleteTransaction = false,
    this.groupIdDeletedIndex,
    this.successDeleteBudget = false,
    this.imageUrl,
    this.imageBytes,
    this.itemCategories = const [],
    this.itemCategoryHistoriesCurrentBudgetId = const [],
    this.groupCategories = const [],
    this.groupCategoryHistoriesCurrentBudgetId = const [],
    this.account,
    this.itemCategoryParam,
    this.itemCategoryHistoryParam,
    this.groupCategoryHistoriesParam = const [],
    this.itemCategoryHistoriesParam = const [],
    this.insertGroupCategoryHistorySuccess = false,
    this.updateGroupCategoryHistorySuccess = false,
    this.pickerColor = const [],
    this.currentColor = const [],
    this.searchResultGroupCategory = const [],
    this.successUpdateBudget = false,
    this.leftToBudget,
  });

  final ItemCategoryHistory? itemCategoryHistory;
  final int? hexColor;
  final String? failure;
  final bool successUpdate;
  final bool successInsert;
  final bool? successDelete;
  final bool successDeleteTransaction;
  final List<ItemCategoryTransaction> itemCategoryTransactions;
  final List<GroupCategoryHistory>? groupCategoryHistories;
  final bool addNewItemCategory;
  final Budget? budget;
  final GroupCategoryHistory? groupCategoryHistory;
  final ItemCategoryTransaction? itemCategoryTransaction;
  final int? groupIdDeletedIndex;
  final bool successDeleteBudget;
  final String? imageUrl;
  final Uint8List? imageBytes;

  /// list of all group category that exist in the database
  final List<GroupCategory> groupCategories;

  /// List of all item categories in the database
  final List<ItemCategory> itemCategories;
  final List<ItemCategoryHistory> itemCategoryHistoriesCurrentBudgetId;
  final List<GroupCategoryHistory> groupCategoryHistoriesCurrentBudgetId;
  final Account? account;
  final ItemCategory? itemCategoryParam;
  final ItemCategoryHistory? itemCategoryHistoryParam;
  final List<GroupCategoryHistory> groupCategoryHistoriesParam;
  final List<ItemCategoryHistory> itemCategoryHistoriesParam;
  final bool insertGroupCategoryHistorySuccess;
  final bool updateGroupCategoryHistorySuccess;
  final List<Color> pickerColor;
  final List<Color> currentColor;
  final List<GroupCategory> searchResultGroupCategory;
  final bool successUpdateBudget;
  final double? leftToBudget;

  CategoryState copyWith({
    ItemCategoryHistory? itemCategoryHistory,
    int? hexColor,
    String? failure,
    bool? successUpdate,
    bool? successDelete,
    bool? successDeleteTransaction,
    List<ItemCategoryTransaction>? itemCategoryTransactions,
    List<GroupCategoryHistory>? groupCategoryHistories,
    List<GroupCategoryHistory>? groupCategoryHistoriesCurrentBudgetId,
    Budget? budget,
    bool? addNewItemCategory,
    GroupCategoryHistory? groupCategoryHistory,
    bool? successInsert,
    ItemCategoryTransaction? itemCategoryTransaction,
    List<bool>? expandListTileValue,
    int? groupIdDeletedIndex,
    bool? successDeleteBudget,
    String? imageUrl,
    Uint8List? imageBytes,
    List<ItemCategory>? itemCategories,
    List<ItemCategoryHistory>? itemCategoryHistoriesCurrentBudgetId,
    GroupCategoryHistory? groupCategory,
    List<GroupCategory>? groupCategories,
    Account? account,
    ItemCategory? itemCategoryParam,
    ItemCategoryHistory? itemCategoryHistoryParam,
    List<GroupCategoryHistory>? groupCategoryHistoriesParam,
    List<ItemCategoryHistory>? itemCategoryHistoriesParam,
    bool? insertGroupCategoryHistorySuccess,
    bool? updateGroupCategoryHistorySuccess,
    List<Color>? pickerColor,
    List<Color>? currentColor,
    List<GroupCategory>? searchResultGroupCategory,
    bool? successUpdateBudget,
    double? leftToBudget,
  }) {
    return CategoryState(
      itemCategoryHistory: itemCategoryHistory ?? this.itemCategoryHistory,
      hexColor: hexColor ?? this.hexColor,
      failure: failure ?? this.failure,
      successUpdate: successUpdate ?? this.successUpdate,
      successDelete: successDelete ?? this.successDelete,
      successDeleteTransaction:
          successDeleteTransaction ?? this.successDeleteTransaction,
      itemCategoryTransactions:
          itemCategoryTransactions ?? this.itemCategoryTransactions,
      groupCategoryHistories:
          groupCategoryHistories ?? this.groupCategoryHistories,
      budget: budget ?? this.budget,
      addNewItemCategory: addNewItemCategory ?? this.addNewItemCategory,
      groupCategoryHistory: groupCategoryHistory ?? this.groupCategoryHistory,
      successInsert: successInsert ?? this.successInsert,
      itemCategoryTransaction:
          itemCategoryTransaction ?? this.itemCategoryTransaction,
      groupIdDeletedIndex: groupIdDeletedIndex ?? this.groupIdDeletedIndex,
      successDeleteBudget: successDeleteBudget ?? this.successDeleteBudget,
      imageUrl: imageUrl ?? this.imageUrl,
      imageBytes: imageBytes ?? this.imageBytes,
      itemCategories: itemCategories ?? this.itemCategories,
      itemCategoryHistoriesCurrentBudgetId:
          itemCategoryHistoriesCurrentBudgetId ??
              this.itemCategoryHistoriesCurrentBudgetId,
      groupCategories: groupCategories ?? this.groupCategories,
      groupCategoryHistoriesCurrentBudgetId:
          groupCategoryHistoriesCurrentBudgetId ??
              this.groupCategoryHistoriesCurrentBudgetId,
      account: account ?? this.account,
      itemCategoryParam: itemCategoryParam ?? this.itemCategoryParam,
      itemCategoryHistoryParam:
          itemCategoryHistoryParam ?? this.itemCategoryHistoryParam,
      groupCategoryHistoriesParam:
          groupCategoryHistoriesParam ?? this.groupCategoryHistoriesParam,
      itemCategoryHistoriesParam:
          itemCategoryHistoriesParam ?? this.itemCategoryHistoriesParam,
      insertGroupCategoryHistorySuccess: insertGroupCategoryHistorySuccess ??
          this.insertGroupCategoryHistorySuccess,
      updateGroupCategoryHistorySuccess: updateGroupCategoryHistorySuccess ??
          this.updateGroupCategoryHistorySuccess,
      pickerColor: pickerColor ?? this.pickerColor,
      currentColor: currentColor ?? this.currentColor,
      searchResultGroupCategory:
          searchResultGroupCategory ?? this.searchResultGroupCategory,
      successUpdateBudget: successUpdateBudget ?? this.successUpdateBudget,
      leftToBudget: leftToBudget ?? this.leftToBudget,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryState &&
        other.itemCategoryHistory == itemCategoryHistory &&
        other.hexColor == hexColor &&
        other.failure == failure &&
        other.successUpdate == successUpdate &&
        other.successDelete == successDelete &&
        other.successDeleteTransaction == successDeleteTransaction &&
        other.itemCategoryTransactions == itemCategoryTransactions &&
        other.groupCategoryHistories == groupCategoryHistories &&
        other.budget == budget &&
        other.addNewItemCategory == addNewItemCategory &&
        other.groupCategoryHistory == groupCategoryHistory &&
        other.successInsert == successInsert &&
        other.itemCategoryTransaction == itemCategoryTransaction &&
        other.groupIdDeletedIndex == groupIdDeletedIndex &&
        other.successDeleteBudget == successDeleteBudget &&
        other.imageUrl == imageUrl &&
        other.imageBytes == imageBytes &&
        listEquals(other.itemCategories, itemCategories) &&
        listEquals(
          other.itemCategoryHistoriesCurrentBudgetId,
          itemCategoryHistoriesCurrentBudgetId,
        ) &&
        listEquals(other.groupCategories, groupCategories) &&
        listEquals(
          other.groupCategoryHistoriesCurrentBudgetId,
          groupCategoryHistoriesCurrentBudgetId,
        ) &&
        other.account == account &&
        other.itemCategoryParam == itemCategoryParam &&
        other.itemCategoryHistoryParam == itemCategoryHistoryParam &&
        listEquals(
          other.groupCategoryHistoriesParam,
          groupCategoryHistoriesParam,
        ) &&
        listEquals(
          other.itemCategoryHistoriesParam,
          itemCategoryHistoriesParam,
        ) &&
        other.insertGroupCategoryHistorySuccess ==
            insertGroupCategoryHistorySuccess &&
        other.updateGroupCategoryHistorySuccess ==
            updateGroupCategoryHistorySuccess &&
        listEquals(other.pickerColor, pickerColor) &&
        listEquals(other.currentColor, currentColor) &&
        listEquals(
          other.searchResultGroupCategory,
          searchResultGroupCategory,
        ) &&
        other.successUpdateBudget == successUpdateBudget &&
        other.leftToBudget == leftToBudget;
  }

  @override
  int get hashCode =>
      itemCategoryHistory.hashCode ^
      hexColor.hashCode ^
      failure.hashCode ^
      successUpdate.hashCode ^
      successDelete.hashCode ^
      successDeleteTransaction.hashCode ^
      itemCategoryTransactions.hashCode ^
      groupCategoryHistories.hashCode ^
      budget.hashCode ^
      addNewItemCategory.hashCode ^
      groupCategoryHistory.hashCode ^
      successInsert.hashCode ^
      itemCategoryTransaction.hashCode ^
      groupIdDeletedIndex.hashCode ^
      successDeleteBudget.hashCode ^
      imageUrl.hashCode ^
      imageBytes.hashCode ^
      itemCategories.hashCode ^
      itemCategoryHistoriesCurrentBudgetId.hashCode ^
      groupCategories.hashCode ^
      groupCategoryHistoriesCurrentBudgetId.hashCode ^
      account.hashCode ^
      itemCategoryParam.hashCode ^
      itemCategoryHistoryParam.hashCode ^
      groupCategoryHistoriesParam.hashCode ^
      itemCategoryHistoriesParam.hashCode ^
      insertGroupCategoryHistorySuccess.hashCode ^
      updateGroupCategoryHistorySuccess.hashCode ^
      pickerColor.hashCode ^
      currentColor.hashCode ^
      searchResultGroupCategory.hashCode ^
      successUpdateBudget.hashCode ^
      leftToBudget.hashCode;
}
