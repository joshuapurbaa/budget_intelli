part of 'financial_dashboard_cubit.dart';

final class FinancialDashboardState extends Equatable {
  FinancialDashboardState({
    String? selectedMonth,
    this.isIncome = false,
  }) : selectedMonth = selectedMonth ?? _getCurrentMonth();

  final String selectedMonth;
  final bool isIncome;

  static String _getCurrentMonth() {
    final now = DateTime.now();
    return AppStrings.monthListFullEn[now.month - 1];
  }

  FinancialDashboardState copyWith({
    String? selectedMonth,
    bool? isIncome,
  }) {
    return FinancialDashboardState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  @override
  List<Object> get props => [
        selectedMonth,
        isIncome,
      ];
}
