part of 'insight_cubit.dart';

@immutable
final class InsightState {
  const InsightState({
    required this.loading,
    required this.itemCategories,
    required this.allTransactions,
    required this.weeklyTransactions,
    required this.oneMonthTransactions,
    required this.threeMonthTransactions,
    required this.sixMonthTransactions,
    required this.nineMonthTransactions,
    required this.twelveMonthTransactions,
    this.totalTransactionAmounts = const [],
    this.dailyTransactions = const {},
    this.monthlyTransactions = const {},
    this.yearlyTransactions = const {},
    this.monthlyIncomeMap = const {},
    this.monthlyExpenseMap = const {},
    this.selectedFrequency = 'Daily',
  });

  final bool loading;
  final List<ItemCategoryHistory> itemCategories;
  final List<ItemCategoryTransaction> allTransactions;
  final List<ItemCategoryTransaction> weeklyTransactions;
  final List<ItemCategoryTransaction> oneMonthTransactions;
  final List<ItemCategoryTransaction> threeMonthTransactions;
  final List<ItemCategoryTransaction> sixMonthTransactions;
  final List<ItemCategoryTransaction> nineMonthTransactions;
  final List<ItemCategoryTransaction> twelveMonthTransactions;
  final List<double> totalTransactionAmounts;
  final Map<String, double> dailyTransactions;
  final Map<String, double> monthlyTransactions;
  final Map<String, double> yearlyTransactions;
  final Map<String, double> monthlyIncomeMap;
  final Map<String, double> monthlyExpenseMap;
  final String selectedFrequency;

  InsightState copyWith({
    bool? loading,
    List<ItemCategoryHistory>? itemCategories,
    List<ItemCategoryTransaction>? allTransactions,
    List<ItemCategoryTransaction>? weeklyTransactions,
    List<ItemCategoryTransaction>? oneMonthTransactions,
    List<ItemCategoryTransaction>? threeMonthTransactions,
    List<ItemCategoryTransaction>? sixMonthTransactions,
    List<ItemCategoryTransaction>? nineMonthTransactions,
    List<ItemCategoryTransaction>? twelveMonthTransactions,
    List<double>? totalTransactionAmounts,
    Map<String, double>? dailyTransactions,
    Map<String, double>? monthlyTransactions,
    Map<String, double>? yearlyTransactions,
    Map<String, double>? monthlyIncomeMap,
    Map<String, double>? monthlyExpenseMap,
    String? selectedFrequency,
  }) {
    return InsightState(
      loading: loading ?? this.loading,
      itemCategories: itemCategories ?? this.itemCategories,
      allTransactions: allTransactions ?? this.allTransactions,
      weeklyTransactions: weeklyTransactions ?? this.weeklyTransactions,
      oneMonthTransactions: oneMonthTransactions ?? this.oneMonthTransactions,
      threeMonthTransactions:
          threeMonthTransactions ?? this.threeMonthTransactions,
      sixMonthTransactions: sixMonthTransactions ?? this.sixMonthTransactions,
      nineMonthTransactions:
          nineMonthTransactions ?? this.nineMonthTransactions,
      twelveMonthTransactions:
          twelveMonthTransactions ?? this.twelveMonthTransactions,
      totalTransactionAmounts:
          totalTransactionAmounts ?? this.totalTransactionAmounts,
      dailyTransactions: dailyTransactions ?? this.dailyTransactions,
      monthlyTransactions: monthlyTransactions ?? this.monthlyTransactions,
      yearlyTransactions: yearlyTransactions ?? this.yearlyTransactions,
      monthlyIncomeMap: monthlyIncomeMap ?? this.monthlyIncomeMap,
      monthlyExpenseMap: monthlyExpenseMap ?? this.monthlyExpenseMap,
      selectedFrequency: selectedFrequency ?? this.selectedFrequency,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InsightState &&
        other.loading == loading &&
        listEquals(other.itemCategories, itemCategories) &&
        listEquals(other.allTransactions, allTransactions) &&
        listEquals(other.weeklyTransactions, weeklyTransactions) &&
        listEquals(other.oneMonthTransactions, oneMonthTransactions) &&
        listEquals(other.threeMonthTransactions, threeMonthTransactions) &&
        listEquals(other.sixMonthTransactions, sixMonthTransactions) &&
        listEquals(other.nineMonthTransactions, nineMonthTransactions) &&
        listEquals(other.twelveMonthTransactions, twelveMonthTransactions) &&
        listEquals(other.totalTransactionAmounts, totalTransactionAmounts) &&
        mapEquals(other.dailyTransactions, dailyTransactions) &&
        mapEquals(other.monthlyTransactions, monthlyTransactions) &&
        mapEquals(other.yearlyTransactions, yearlyTransactions) &&
        mapEquals(other.monthlyIncomeMap, monthlyIncomeMap) &&
        mapEquals(other.monthlyExpenseMap, monthlyExpenseMap) &&
        other.selectedFrequency == selectedFrequency;
  }

  @override
  int get hashCode {
    return loading.hashCode ^
        itemCategories.hashCode ^
        allTransactions.hashCode ^
        weeklyTransactions.hashCode ^
        oneMonthTransactions.hashCode ^
        threeMonthTransactions.hashCode ^
        sixMonthTransactions.hashCode ^
        nineMonthTransactions.hashCode ^
        twelveMonthTransactions.hashCode ^
        totalTransactionAmounts.hashCode ^
        dailyTransactions.hashCode ^
        selectedFrequency.hashCode ^
        monthlyTransactions.hashCode ^
        yearlyTransactions.hashCode ^
        monthlyIncomeMap.hashCode ^
        monthlyExpenseMap.hashCode;
  }
}
