part of 'tracking_cubit.dart';

@immutable
final class TrackingState {
  const TrackingState({
    required this.dailyTransactions,
    required this.weeklyTransactions,
    required this.monthlyTransactions,
    required this.yearlyTransactions,
    required this.itemCategories,
    required this.allTransactions,
    this.loading = false,
  });

  final List<ItemCategoryTransaction> dailyTransactions;
  final List<ItemCategoryTransaction> weeklyTransactions;
  final List<ItemCategoryTransaction> monthlyTransactions;
  final List<ItemCategoryTransaction> yearlyTransactions;
  final List<ItemCategoryTransaction> allTransactions;
  final List<ItemCategoryHistory> itemCategories;
  final bool loading;

  TrackingState copyWith({
    List<ItemCategoryTransaction>? dailyTransactions,
    List<ItemCategoryTransaction>? weeklyTransactions,
    List<ItemCategoryTransaction>? monthlyTransactions,
    List<ItemCategoryTransaction>? yearlyTransactions,
    List<ItemCategoryTransaction>? allTransactions,
    List<ItemCategoryHistory>? itemCategories,
    bool? loading,
  }) {
    return TrackingState(
      dailyTransactions: dailyTransactions ?? this.dailyTransactions,
      weeklyTransactions: weeklyTransactions ?? this.weeklyTransactions,
      monthlyTransactions: monthlyTransactions ?? this.monthlyTransactions,
      yearlyTransactions: yearlyTransactions ?? this.yearlyTransactions,
      itemCategories: itemCategories ?? this.itemCategories,
      allTransactions: allTransactions ?? this.allTransactions,
      loading: loading ?? this.loading,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrackingState &&
        listEquals(other.dailyTransactions, dailyTransactions) &&
        listEquals(other.weeklyTransactions, weeklyTransactions) &&
        listEquals(other.monthlyTransactions, monthlyTransactions) &&
        listEquals(other.yearlyTransactions, yearlyTransactions) &&
        listEquals(other.allTransactions, allTransactions) &&
        listEquals(other.itemCategories, itemCategories) &&
        other.loading == loading;
  }

  @override
  int get hashCode {
    return dailyTransactions.hashCode ^
        weeklyTransactions.hashCode ^
        monthlyTransactions.hashCode ^
        yearlyTransactions.hashCode ^
        allTransactions.hashCode ^
        itemCategories.hashCode ^
        loading.hashCode;
  }
}
