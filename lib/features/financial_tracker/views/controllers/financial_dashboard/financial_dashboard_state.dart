part of 'financial_dashboard_cubit.dart';

enum SummaryFilterBy { day, week, month }

final class FinancialDashboardState extends Equatable {
  FinancialDashboardState({
    String? selectedMonth,
    this.isIncome = false,
    this.dayTransactions = const [],
    this.weekTransactions = const [],
    this.monthTransactions = const [],
    this.monthNumStr,
    this.dayTotalAmount = 0.0,
    this.weekTotalAmount = 0.0,
    this.monthTotalAmount = 0.0,
    this.filterBy = SummaryFilterBy.day,
  }) : selectedMonth = selectedMonth ?? _getCurrentMonth();

  final String selectedMonth;
  final String? monthNumStr;
  final bool isIncome;
  final List<FinancialTransaction> dayTransactions;
  final List<FinancialTransaction> weekTransactions;
  final List<FinancialTransaction> monthTransactions;
  final double dayTotalAmount;
  final double weekTotalAmount;
  final double monthTotalAmount;
  final SummaryFilterBy filterBy;

  FinancialDashboardState copyWith({
    String? selectedMonth,
    bool? isIncome,
    List<FinancialTransaction>? dayTransactions,
    List<FinancialTransaction>? weekTransactions,
    List<FinancialTransaction>? monthTransactions,
    String? monthNumStr,
    double? dayTotalAmount,
    double? weekTotalAmount,
    double? monthTotalAmount,
    SummaryFilterBy? filterBy,
  }) {
    return FinancialDashboardState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      isIncome: isIncome ?? this.isIncome,
      dayTransactions: dayTransactions ?? this.dayTransactions,
      weekTransactions: weekTransactions ?? this.weekTransactions,
      monthTransactions: monthTransactions ?? this.monthTransactions,
      monthNumStr: monthNumStr ?? this.monthNumStr,
      dayTotalAmount: dayTotalAmount ?? this.dayTotalAmount,
      weekTotalAmount: weekTotalAmount ?? this.weekTotalAmount,
      monthTotalAmount: monthTotalAmount ?? this.monthTotalAmount,
      filterBy: filterBy ?? this.filterBy,
    );
  }

  @override
  List<Object?> get props => [
        selectedMonth,
        isIncome,
        dayTransactions,
        weekTransactions,
        monthTransactions,
        monthNumStr,
        dayTotalAmount,
        weekTotalAmount,
        monthTotalAmount,
        filterBy,
      ];

  static String _getCurrentMonth() {
    final now = DateTime.now();
    return AppStrings.monthListFullEn[now.month - 1];
  }
}
