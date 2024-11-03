part of 'financial_dashboard_cubit.dart';

final class FinancialDashboardState extends Equatable {
  FinancialDashboardState({
    String? selectedMonth,
    this.isIncome = false,
    this.transactions = const [],
    this.monthNumStr,
  }) : selectedMonth = selectedMonth ?? _getCurrentMonth();

  final String selectedMonth;
  final String? monthNumStr;
  final bool isIncome;
  final List<FinancialTransaction> transactions;

  FinancialDashboardState copyWith({
    String? selectedMonth,
    bool? isIncome,
    List<FinancialTransaction>? transactions,
    String? monthNumStr,
  }) {
    return FinancialDashboardState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      isIncome: isIncome ?? this.isIncome,
      transactions: transactions ?? this.transactions,
      monthNumStr: monthNumStr ?? this.monthNumStr,
    );
  }

  @override
  List<Object?> get props => [
        selectedMonth,
        isIncome,
        transactions,
        monthNumStr,
      ];

  static String _getCurrentMonth() {
    final now = DateTime.now();
    return AppStrings.monthListFullEn[now.month - 1];
  }
}
